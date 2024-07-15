import sys
import json
import pyspark
from pyspark.sql.functions import col, collect_list, array_join, struct, array_distinct, count

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.window import Window
from pyspark.sql.functions import row_number

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
job.commit()

#WE BEGIN BY RECREATING THE TAGS DATABASE
## READ TAGS DATASET
tags_dataset_path = "s3://tedx-2024-data-mazzoleni-g/tags.csv"
tags_dataset = spark.read.option("header","true").csv(tags_dataset_path)


# LOAD TALK DATA
tedx_dataset_path = "s3://tedx-2024-data-mazzoleni-g/final_list.csv"
tedx_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(tedx_dataset_path)
tedx_dataset.printSchema()

tags_dataset_data= tags_dataset.join(tedx_dataset, tags_dataset.id == tedx_dataset.id, "left") \
    .select(tags_dataset["tag"], tedx_dataset["id"].alias("talk_id"),tedx_dataset["title"].alias("talk_title"),tedx_dataset["speakers"].alias("talk_speaker"))

# GROUP BY TAGS AND SPEAKERS
speaker_counts = tags_dataset_data.groupBy("tag", "talk_speaker").count()

#NOW, WE CAN FIND THE MOST FREQUENT SPEAKER FOR EACH TAG
window_spec = Window.partitionBy("tag").orderBy(col("count").desc())
#WE RANK ALL SPEAKERS AND THEN ONLY KEEP THE ONE IN FIRST POSITION
ranked_speakers = speaker_counts.withColumn("rank", row_number().over(window_spec)).filter(col("rank") == 1).drop("rank", "count")

# CREATE THE AGGREGATE MODEL, ONLY SHOWING TAG NAME AND MOST FREQUENT SPEAKER
tags_dataset_agg = ranked_speakers.groupBy(col("tag").alias("_id")) \
    .agg(collect_list(col("talk_speaker")).alias("most_frequent_speakers"))

tags_dataset_agg.printSchema()



# CREATE A NEW MONGODB COLLECTION
write_mongo_options = {
    "connectionName": "TEDx 2024 by GabTheBest",
    "database": "unibg_tedx_2024",
    "collection": "Topics_most_common_speakers",
    "ssl": "true",
    "ssl.domain_match": "false"}
from awsglue.dynamicframe import DynamicFrame
tags_dataset_dynamic_frame = DynamicFrame.fromDF(tags_dataset_agg, glueContext, "nested")

glueContext.write_dynamic_frame.from_options(tags_dataset_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)


