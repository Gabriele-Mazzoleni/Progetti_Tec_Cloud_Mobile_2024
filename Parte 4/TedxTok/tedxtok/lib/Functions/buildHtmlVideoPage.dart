 String buildHtmlVideoPage(String videoUrl) {
    // Estrae l'ID del talk dall'URL
    final talkId = videoUrl.split('/').last;
    final embedUrl = 'https://embed.ted.com/talks/$talkId';

    return '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: black;
          }
          iframe {
            width: 100%;
            height: 100%;
          }
        </style>
      </head>
      <body>
        <iframe src="$embedUrl" frameborder="0" allowfullscreen></iframe>
      </body>
      </html>
    ''';
  }