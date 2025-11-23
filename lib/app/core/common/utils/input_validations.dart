import 'package:intl/intl.dart';
import 'package:my_code_place/app/core/common/extensions/locale_extension.dart';
import 'package:my_code_place/app/core/common/utils/datetime_utils.dart';

class InputValidations {
  static String? simpleInputValidation(String? value, {int? minLengh}) {
    if (value == null || value.isEmpty) {
      return 'fill_this_field'.t;
    }
    if (minLengh != null && value.length < minLengh) {
      return 'fill_this_with_minimum'.translate([minLengh.toString()]);
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'fill_this_field'.t;
    }
    return null;
  }

  static String? numberValidation(
    String? value, {
    num? minValue,
    num? maxValue,
  }) {
    if (value == null || value.isEmpty) {
      return 'fill_this_field'.t;
    }
    if (minValue != null && num.parse(value) < minValue) {
      return '${'value_must_be_greater_than'.t} $minValue';
    }
    if (maxValue != null && num.parse(value) > maxValue) {
      return '${'value_must_be_less_than'.t} $maxValue';
    }
    return null;
  }

  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'insert_your_email'.t;
    }
    if (value.length < 10) {
      return 'insert_full_email'.t;
    }
    if (value.contains('@') && value.contains('.com')) {
      return null;
    }
    return 'invalid_email'.t;
  }

  static String? dateValidation(
    String? value, {
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    //dd/MM/yyyy
    if (value == null || value.isEmpty) {
      return 'required_field'.t;
    }
    int? day;
    int? month;
    int? year;

    if (value.length >= 2) {
      day = int.parse(value.substring(0, 2));

      if (day < 1 || day > 31) {
        return 'invalid_day'.t;
      }
    }
    if (value.length >= 5) {
      month = int.parse(value.substring(3, 5));

      if (month < 1 || month > 12) {
        return 'invalid_month'.t;
      }
    }
    if (value.length >= 10) {
      year = int.parse(value.substring(6, 10));

      if (year < 1900 || year > 2100) {
        return 'invalid_year'.t;
      }
    }
    if (value.length < 10 || value.length > 10) {
      return 'insert_complete_date'.t;
    }

    var date = DateTime(year!, month!, day!);

    if (minDate != null && date.isBefore(minDate)) {
      return '${'insert_date_after'.t} ${DateFormat('dd/MM/yyyy').format(minDate)}';
    }
    if (maxDate != null && date.isAfter(maxDate)) {
      return '${'insert_date_before'.t} ${DateFormat('dd/MM/yyyy').format(maxDate)}';
    }

    return null;
  }

  // min and max == hh:mm
  static String? hourValidation(
    String? value, {
    String? minDate,
    String? maxDate,
  }) {
    //hh:mm
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    int? hour;
    int? minute;

    if (value.length >= 2) {
      hour = int.parse(value.substring(0, 2));

      if (hour < 0 || hour > 23) {
        return 'Hora inválida';
      }
    }

    if (value.length >= 5) {
      minute = int.parse(value.substring(3, 5));

      if (minute < 0 || minute > 59) {
        return 'Minuto inválido';
      }
    }

    if (value.length < 5 || value.length > 5) {
      return 'Insira uma hora completa';
    }

    var date = DateTime(0, 0, 0, hour!, minute!);

    if (minDate != null) {
      var thisdate = DateTimeUtils.getDateFromHour(minDate);
      if (thisdate == null) {
        return 'Insira uma hora inicial';
      }
      if (thisdate.isAfter(date)) {
        return 'Insira uma hora superior a $minDate';
      }
    }

    if (maxDate != null) {
      var thisdate = DateTimeUtils.getDateFromHour(maxDate);
      if (thisdate == null) {
        return 'Insira uma hora final';
      }
      if (thisdate.isBefore(date)) {
        return 'Insira uma hora inferior a $maxDate';
      }
    }
    return null;
  }
}
