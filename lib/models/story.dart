

import 'package:soical_media_app/models/story_user.dart';

enum MediaType {
  image,
  video,
}

class Story {
  final String url;
  final MediaType media;
  final Duration duration;
  final User user;

  const Story({
    required this.url,
    required this.media,
    required this.duration,
    required this.user,
  });
}
