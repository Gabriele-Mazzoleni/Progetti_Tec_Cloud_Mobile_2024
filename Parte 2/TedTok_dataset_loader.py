###### TEDx-Load-Aggregate-Model
######

import sys
import json
import pyspark
from pyspark.sql.functions import col, collect_list, array_join, struct

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job




##### FROM FILES
tedx_dataset_path = "s3://tedx-2024-data-mazzoleni-g/final_list.csv"

###### READ PARAMETERS
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

##### START JOB CONTEXT AND JOB
sc = SparkContext()


glueContext = GlueContext(sc)
spark = glueContext.spark_session

job = Job(glueContext)
job.init(args['JOB_NAME'], args)


#### READ INPUT FILES TO CREATE AN INPUT DATASET
tedx_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(tedx_dataset_path)
    
tedx_dataset.printSchema()


#### FILTER ITEMS WITH NULL POSTING KEY
count_items = tedx_dataset.count()
count_items_null = tedx_dataset.filter("id is not null").count()

print(f"Number of items from RAW DATA {count_items}")
print(f"Number of items from RAW DATA with NOT NULL KEY {count_items_null}")

## READ THE DETAILS
details_dataset_path = "s3://tedx-2024-data-mazzoleni-g/details.csv"
details_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(details_dataset_path)

details_dataset = details_dataset.select(col("id").alias("id_ref"),
                                         col("description"),
                                         col("duration"),
                                         col("publishedAt"))

# AND JOIN WITH THE MAIN TABLE
tedx_dataset_main = tedx_dataset.join(details_dataset, tedx_dataset.id == details_dataset.id_ref, "left") \
    .drop("id_ref")

tedx_dataset_main.printSchema()

## READ TAGS DATASET
tags_dataset_path = "s3://tedx-2024-data-mazzoleni-g/tags.csv"
tags_dataset = spark.read.option("header","true").csv(tags_dataset_path)


# CREATE THE AGGREGATE MODEL, ADD TAGS TO TEDX_DATASET
tags_dataset_agg = tags_dataset.groupBy(col("id").alias("id_ref")).agg(collect_list("tag").alias("tags"))
tags_dataset_agg.printSchema()
tedx_dataset_agg = tedx_dataset_main.join(tags_dataset_agg, tedx_dataset.id == tags_dataset_agg.id_ref, "left") \
    .drop("id_ref") \
    .select(col("id").alias("_id"), col("*")) \
    .drop("id") \

tedx_dataset_agg.printSchema()

# ADD IMAGES TO DATASET
images_dataset_path = "s3://tedx-2024-data-mazzoleni-g/images.csv"
images_dataset = details_dataset = spark.read.option("header","true").csv(images_dataset_path)

# AGGREGATED IMAGE DATASET
images_dataset_agg = images_dataset.select(col("id").alias("id_ref"),col("url").alias("imageUrl"))
images_dataset_agg.printSchema()

tedx_dataset_full = tedx_dataset_agg.join(images_dataset_agg, tedx_dataset_agg._id == images_dataset_agg.id_ref, "left") \
    .drop("id_ref") \
    .select(col("_id"), col("*")) \
    
tedx_dataset_full.printSchema()

# ADDITION OF 'WATCH NEXT' LINKS TO DATASET
related_dataset_path = "s3://tedx-2024-data-mazzoleni-g/related_videos.csv"
related_dataset = details_dataset = spark.read.option("header","true").csv(related_dataset_path)

related_dataset_with_urls=related_dataset.join(tedx_dataset, related_dataset.internalId == tedx_dataset.id, "left") \
    .select(related_dataset["id"], related_dataset["related_id"], related_dataset["title"], related_dataset["presenterDisplayName"], tedx_dataset["url"].alias("related_url"))

#AGGREGATE WATCH NEXT DATA AND JOIN TO MAIN DATASET
related_dataset_agg = related_dataset_with_urls.groupBy(col("id").alias("id_ref")) \
    .agg(collect_list(struct(col("related_id").alias("related_video_ids"), col("title").alias("related_video_title"),
     col("presenterDisplayName").alias("related_presentedBy"), col("related_url"))).alias("Related_videos"))

related_dataset_agg.printSchema()

tedTok_dataset_full = tedx_dataset_full.join(related_dataset_agg, tedx_dataset_agg._id == related_dataset_agg.id_ref, "left") \
    .drop("id_ref") \
    .select(col("_id"), col("*")) \
    
tedTok_dataset_full.printSchema()

write_mongo_options = {
    "connectionName": "TEDx 2024 by GabTheBest",
    "database": "unibg_tedx_2024",
    "collection": "TedTok_data",
    "ssl": "true",
    "ssl.domain_match": "false"}
from awsglue.dynamicframe import DynamicFrame
tedx_dataset_dynamic_frame = DynamicFrame.fromDF(tedTok_dataset_full, glueContext, "nested")

glueContext.write_dynamic_frame.from_options(tedx_dataset_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)


