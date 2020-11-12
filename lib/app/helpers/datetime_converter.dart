import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String convertStamp(Timestamp _stamp) {
  if (_stamp != null) {
    final String formattedDate = DateFormat('dd/MM/yyyy - kk:mm')
        .format(Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate());
    return formattedDate;
  } else {
    return null;
  }
}

String convertStamptoTime(Timestamp _stamp) {
  if (_stamp != null) {
    final String formattedDate = DateFormat('kk:mm')
        .format(Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate());
    return formattedDate;
  } else {
    return null;
  }
}
