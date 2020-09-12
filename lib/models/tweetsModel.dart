class TweetModel {
  String tid;
  String profilePic;
  String uid;
  String tweet;
  String imgUrl;
  List likes;
  double commentCount;
  double shares;

  TweetModel(
      {this.tid,
      this.profilePic,
      this.commentCount,
      this.imgUrl,
      this.likes,
      this.shares,
      this.tweet,
      this.uid});
}
