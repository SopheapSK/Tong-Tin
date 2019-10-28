class ListNotificationModel {
  int totalRecord;
  int totalPage;
  List<Notifications> notifications;

  ListNotificationModel({this.totalRecord, this.totalPage, this.notifications});

  ListNotificationModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    totalPage = json['total_page'];
    if (json['notifications'] != null) {
      notifications = new List<Notifications>();
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_record'] = this.totalRecord;
    data['total_page'] = this.totalPage;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String contentSms;
  String createOn;
  String titleEn;
  String titleKh;
  String titleCh;

  Notifications(
      {this.contentSms,
        this.createOn,
        this.titleEn,
        this.titleKh,
        this.titleCh});

  Notifications.fromJson(Map<String, dynamic> json) {
    contentSms = json['contentSms'];
    createOn = json['createOn'];
    titleEn = json['title_en'];
    titleKh = json['title_kh'];
    titleCh = json['title_ch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contentSms'] = this.contentSms;
    data['createOn'] = this.createOn;
    data['title_en'] = this.titleEn;
    data['title_kh'] = this.titleKh;
    data['title_ch'] = this.titleCh;
    return data;
  }
}
