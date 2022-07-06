import 'package:flutter/material.dart';
import 'package:flutter_gram/screens/add_post_screen.dart';
import 'package:flutter_gram/screens/feed_screen.dart';

const WebScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('notif'),
  Text('profile'),
];
