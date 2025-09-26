import 'package:mi_anddes_mobile_app/model/onsite_induction.dart';
import 'package:mi_anddes_mobile_app/model/remote_induction.dart';
import 'package:mi_anddes_mobile_app/model/team_member.dart';

import 'ceo_presentation.dart';
import 'elearning_content.dart';
import 'first_day_information_item.dart';

class Onboarding {
  CEOPresentation? ceoPresentation;
  List<FirstDayInformationItem>? firstDayInformationItems;
  OnsiteInduction? onSiteInduction;
  RemoteInduction? remoteInduction;
  List<ELearningContent>? eLearningContents;
  List<TeamMember>? team;

  Onboarding(
      {this.ceoPresentation,
      this.firstDayInformationItems,
      this.onSiteInduction,
      this.remoteInduction,
      this.eLearningContents,
      this.team});

  static fromJson(Map<String, dynamic> json) => Onboarding(
        ceoPresentation: json['ceoPresentation'] == null
            ? null
            : CEOPresentation.fromJson(
                json['ceoPresentation'] as Map<String, dynamic>),
        firstDayInformationItems:
            (json['firstDayInformationItems'] as List<dynamic>?)
                ?.map((e) =>
                    FirstDayInformationItem.fromJson(e as Map<String, dynamic>)
                        as FirstDayInformationItem)
                .toList(),
        onSiteInduction: json['onSiteInduction'] == null
            ? null
            : OnsiteInduction.fromJson(
                json['onSiteInduction'] as Map<String, dynamic>),
        remoteInduction: json['remoteInduction'] == null
            ? null
            : RemoteInduction.fromJson(
                json['remoteInduction'] as Map<String, dynamic>),
        eLearningContents: (json['elearningContents'] as List<dynamic>?)
            ?.map((e) => ELearningContent.fromJson(e as Map<String, dynamic>)
                as ELearningContent)
            .toList(),
        team: (json['team'] as List<dynamic>?)
            ?.map((e) =>
                TeamMember.fromJson(e as Map<String, dynamic>) as TeamMember)
            .toList(),
      );
}
