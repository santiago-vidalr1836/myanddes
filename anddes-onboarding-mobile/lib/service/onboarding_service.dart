import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';
import 'package:mi_anddes_mobile_app/model/elearning_result.dart';
import 'package:mi_anddes_mobile_app/model/first_day_information_item.dart';
import 'package:mi_anddes_mobile_app/model/onboarding.dart';
import 'package:mi_anddes_mobile_app/model/onsite_induction.dart';
import 'package:mi_anddes_mobile_app/model/pending_process_activity.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content_card_answer.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content_result.dart';
import 'package:mi_anddes_mobile_app/model/remote_induction.dart';
import 'package:mi_anddes_mobile_app/model/team_member.dart';

import 'package:mi_anddes_mobile_app/repository/ceo_presentation_repository.dart';
import 'package:mi_anddes_mobile_app/repository/elearning_content_repository.dart';
import 'package:mi_anddes_mobile_app/repository/onsite_induction_repository.dart';
import 'package:mi_anddes_mobile_app/repository/pending_process_activity_repository.dart';
import 'package:mi_anddes_mobile_app/repository/process_activity_repository.dart';
import 'package:mi_anddes_mobile_app/repository/process_repository.dart';
import 'package:mi_anddes_mobile_app/repository/remote_induction_repository.dart';
import 'package:mi_anddes_mobile_app/repository/team_member_repository.dart';
import 'package:mi_anddes_mobile_app/utils/exception/unauthorized_exception.dart';

import '../constants.dart';
import '../model/ceo_presentation.dart';
import '../model/process.dart';
import '../repository/first_day_information_item_repository.dart';
import '../repository/process_activity_content_answer_repository.dart';
import 'auth_service.dart';

class OnboardingService {
  late ProcessRepository _processRepository;
  late ProcessActivityRepository _processActivityRepository;
  late TeamMemberRepository _teamMemberRepository;
  late CEOPresentationRepository _ceoPresentationRepository;
  late OnsiteInductionRepository _onsiteInductionRepository;
  late RemoteInductionRepository _remoteInductionRepository;
  late ELearningContentRepository _eLearningContentRepository;
  late FirstDayInformationItemRepository _firstDayInformationItemRepository;
  late PendingProcessActivityRepository _pendingProcessActivityRepository;
  late ProcessActivityContentCardAnswerRepository
      _processActivityContentCardAnswerRepository;

  OnboardingService() {
    _processRepository = ProcessRepository();
    _processActivityRepository = ProcessActivityRepository();
    _teamMemberRepository = TeamMemberRepository();
    _ceoPresentationRepository = CEOPresentationRepository();
    _onsiteInductionRepository = OnsiteInductionRepository();
    _remoteInductionRepository = RemoteInductionRepository();
    _eLearningContentRepository = ELearningContentRepository();
    _firstDayInformationItemRepository = FirstDayInformationItemRepository();
    _pendingProcessActivityRepository = PendingProcessActivityRepository();
    _processActivityContentCardAnswerRepository =
        ProcessActivityContentCardAnswerRepository();
  }

  Future<void> syncProcess(int userId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse("${Constants.baseUri}/onboarding/$userId/process/");
    final response = await http.get(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        Process process = Process.fromJson(body);
        await _processRepository.deleteAll();
        await _processRepository.add(process);
      } else {
        await _processRepository.deleteAll();
      }
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<void> syncProcessActivity(int userId, int processId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities");
    final response = await http.get(uri, headers: {
      "Authorization": "Bearer ${accessToken?.value ?? ""}",
      "Content-Type": 'application/json',
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      List<ProcessActivity> activities = List<ProcessActivity>.from(
          body.map((model) => ProcessActivity.fromJson(model)));
      await _processActivityRepository.deleteAll();
      await _processActivityRepository.addAll(activities);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<ProcessActivity?> callApiProcessActivityById(
      int userId, int processId, int processActivityId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities/$processActivityId");
    final response = await http.get(uri, headers: {
      "Authorization": "Bearer ${accessToken?.value ?? ""}",
      "Content-Type": 'application/json',
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      ProcessActivity activity = ProcessActivity.fromJson(body);
      return activity;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
    return null;
  }

  Future<void> syncOnboarding(int userId, int processId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities/detail");
    final response = await http.get(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      //log(response.body);
      Onboarding onboarding = Onboarding.fromJson(body);

      await _ceoPresentationRepository.deleteAll();
      await _onsiteInductionRepository.deleteAll();
      await _remoteInductionRepository.deleteAll();
      await _teamMemberRepository.deleteAll();

      if (onboarding.ceoPresentation != null) {
        await _ceoPresentationRepository.add(onboarding.ceoPresentation!);
      }
      if (onboarding.remoteInduction != null) {
        await _remoteInductionRepository.add(onboarding.remoteInduction!);
      }
      if (onboarding.onSiteInduction != null) {
        await _onsiteInductionRepository.add(onboarding.onSiteInduction!);
      }
      if (onboarding.team != null) {
        await _teamMemberRepository.addAll(onboarding.team!);
      }

      if (onboarding.eLearningContents != null &&
          onboarding.eLearningContents!.isNotEmpty) {
        await _eLearningContentRepository.addAll(onboarding.eLearningContents!);
      }
      if (onboarding.firstDayInformationItems != null &&
          onboarding.firstDayInformationItems!.isNotEmpty) {
        await _firstDayInformationItemRepository
            .addAll(onboarding.firstDayInformationItems!);
      }
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<CEOPresentation?> findCEOPresentation() {
    return _ceoPresentationRepository.findFirst();
  }

  Future<RemoteInduction?> findRemoteInduction() {
    return _remoteInductionRepository.findFirst();
  }

  Future<OnsiteInduction?> findOnsiteInduction() {
    return _onsiteInductionRepository.findFirst();
  }

  Future<List<TeamMember>?> findTeam() {
    return _teamMemberRepository.findAll();
  }

  Future<List<ELearningContent>?> findELearningContents() {
    return _eLearningContentRepository.findAll();
  }

  Future<ELearningContent?> findELearningContentsById(int id) async {
    return await _eLearningContentRepository.findById(id);
  }

  Future<List<FirstDayInformationItem>?> findFirstDayInformationItems() {
    return _firstDayInformationItemRepository.findAll();
  }

  Future<Process?> findProcess() {
    return _processRepository.findFirst();
  }

  Future<List<ProcessActivity>?> findActivities() {
    return _processActivityRepository.findAll();
  }

  Future<void> updateWelcomed(int userId, processId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/welcomed");
    final response = await http.put(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      log('Se actualizo correctamente el flag de mostrar bienvenida');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<void> updateActivityCompleted(ProcessActivity processActivity) async {
    try {
      await _processActivityRepository.updateById(processActivity);

      var accessToken = await AuthService().getAccessToken();
      final uri = Uri.parse(
          "${Constants.baseUri}/onboarding/1/process/1/activities/${processActivity.id}");
      final response = await http.put(uri,
          headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
      if (response.statusCode == 200) {
        log('Se actualizo correctamente el flag de completado a la actividad');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      }
    } on Exception {
      await _pendingProcessActivityRepository.add(PendingProcessActivity(
          id: DateTime.now().millisecondsSinceEpoch,
          processActivityId: processActivity.id,
          send: false));
    }
  }

  Future<ProcessActivity?> findProcessActivityByCode(String code) async {
    var activities = await _processActivityRepository.findByActivityCode(code);
    ProcessActivity? activity;
    if (activities != null && activities.isNotEmpty && activities.length == 1) {
      activity = activities.first;
    }
    return activity;
  }

  Future<void> updateCard(
      int parentId, ELearningContentCard eLearningContentCard) async {
    await _eLearningContentRepository.updateCard(
        parentId, eLearningContentCard);
  }

  Future<ELearningResult> getResult(int userId, String processId,
      String processActivityId, int contentId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities/$processActivityId/content/$contentId");

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer ${accessToken?.value ?? ""}",
      "Content-Type": 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      ELearningResult eLearningResult = ELearningResult.fromJson(body);
      return eLearningResult;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
    return ELearningResult(result: null);
  }

  Future<ELearningResult> calculateResult(int userId, String processId,
      String processActivityId, int contentId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities/$processActivityId/content/$contentId");

    var elearningContent = await findELearningContentsById(contentId);

    final response = await http.post(uri,
        headers: {
          "Authorization": "Bearer ${accessToken?.value ?? ""}",
          "Content-Type": 'application/json'
        },
        body: jsonEncode(elearningContent!.toJson()));

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      ELearningResult eLearningResult = ELearningResult.fromJson(body);
      return eLearningResult;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 500) {
      throw Exception();
    }
    return ELearningResult(result: null);
  }

  Future<void> updateContent(
      ProcessActivityContentCardAnswer processActivityContentCardAnswer) async {
    await _processActivityContentCardAnswerRepository
        .updateById(processActivityContentCardAnswer);
  }

  Future<void> updateOption(
      int parentId, ELearningContentCardOption option) async {
    await _eLearningContentRepository.updateOption(parentId, option);
  }

  Future<void> sendPendingELearningContents() async {
    Process? process = await findProcess();
    ProcessActivity? processActivity =
        await findProcessActivityByCode(Constants.ACTIVITY_INDUCTION_ELEARNING);

    List<ProcessActivityContentCardAnswer>? answers =
        await _processActivityContentCardAnswerRepository.findAll();
    if (process != null &&
        processActivity != null &&
        answers != null &&
        answers.isNotEmpty) {
      for (ProcessActivityContentCardAnswer answer in answers) {
        if (!answer.sent) {
          answer.sent = true;
          await updateContent(answer);
        }
      }
    }
  }

  Future<void> sendPendingProcessActivity() async {
    List<PendingProcessActivity>? pendingProcessActivities =
        await _pendingProcessActivityRepository
            .findByFilters("send = ?", ["0"]);
    Process? process = await findProcess();

    var accessToken = await AuthService().getAccessToken();

    if (process != null &&
        pendingProcessActivities != null &&
        pendingProcessActivities.isNotEmpty) {
      for (PendingProcessActivity pending in pendingProcessActivities) {
        try {
          final uri = Uri.parse(
              "${Constants.baseUri}/onboarding/1/process/${process.id}/activities/${pending.processActivityId}");
          final response = await http.put(uri,
              headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
          if (response.statusCode == 200) {
            pending.send = true;
            await _pendingProcessActivityRepository.updateById(pending);
          }
        } on Exception {}
      }
    }
  }

  Future<List<ProcessActivityContent?>> findRemoteProccessActivityContents(
      String processId, String processActivityId) async {
    try {
      List<ELearningContent> contents =
          await _eLearningContentRepository.findAll();
      ProcessActivityContent? processActivityContent;
      var accessToken = await AuthService().getAccessToken();

      List<Response> responses = await Future.wait<
          Response>(contents.map((item) => http.get(
              Uri.parse(
                  "${Constants.baseUri}/onboarding/v2/1/process/$processId/activities/$processActivityId/content?eLearningContentId=${item.id}"),
              headers: {
                "Authorization": "Bearer ${accessToken?.value ?? ""}",
                "Content-Type": 'application/json'
              })));
      List<ELearningContent?> elearningContents = await Future.wait(contents
          .map((item) => _eLearningContentRepository.findById(item.id)));

      List<ProcessActivityContent?> list = responses.map((response) {
        if (response.statusCode == 200) {
          ProcessActivityContent? processActivityContent;
          log("response=${utf8.decode(response.bodyBytes)}");
          if (response.bodyBytes.isNotEmpty) {
            final body = jsonDecode(utf8.decode(response.bodyBytes));
            processActivityContent = ProcessActivityContent.fromJson(body);
          } else {
            if (response.request != null &&
                response.request!.url.queryParameters
                    .containsKey("eLearningContentId")) {
              ELearningContent? eLearningContent = elearningContents.firstWhere(
                  (e) =>
                      e?.id.toString() ==
                      response
                          .request!.url.queryParameters["eLearningContentId"]!);
              if (eLearningContent != null) {
                processActivityContent = ProcessActivityContent(
                    id: 0, content: eLearningContent, cards: [],progress: 0.0);
              } else {
                throw Exception("El curso no existe");
              }
            } else {
              throw Exception("Hubo un error con el llamado al api");
            }
          }
          return processActivityContent;
        } else if (response.statusCode == 401) {
          throw UnauthorizedException();
        } else if (response.statusCode == 500) {
          throw Exception();
        }
      }).toList();

      list.sort((a, b) {
        int result;
        if (a == null ) {
          result = 1;
        } else if (b == null) {
          result = -1;
        } else {
          // Ascending Order
          result = a.content.position!.compareTo(b.content.position!);
        }
        return result;
      });
      return list;
    } catch (e) {
      print(e);
      log("Error findRemoteProccessActivityContents: ${e.toString()}");
      rethrow;
    }
  }

  Future<ProcessActivityContent?> findRemoteProcessActivityContent(
      String processId,
      String processActivityId,
      String eLearningContentId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/v2/1/process/$processId/activities/$processActivityId/content/$eLearningContentId");

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer ${accessToken?.value ?? ""}",
      "Content-Type": 'application/json'
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      ProcessActivityContent processActivityContent =
          ProcessActivityContent.fromJson(body);
      return processActivityContent;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 500) {
      throw Exception();
    }
    return null;
  }

  Future<void> createRemoteProcessActivityContent(String processId,
      String processActivityId, String eLearningContentId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/v2/1/process/$processId/activities/$processActivityId/content/$eLearningContentId");

    final response = await http.post(uri, headers: {
      "Authorization": "Bearer ${accessToken?.value ?? ""}",
      "Content-Type": 'application/json'
    }, body: {});

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 500) {
      throw Exception();
    }
  }

  Future<void> updateRemoteProcessActivityContent(
      String processId,
      String processActivityId,
      String processActivityContentId,
      String processActivityContentCardId,
      ProcessActivityContentCardAnswer? answer) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/v2/1/process/$processId/activities/$processActivityId/content/$processActivityContentId/card/$processActivityContentCardId");

    final response = await http.put(uri,
        headers: {
          "Authorization": "Bearer ${accessToken?.value ?? ""}",
          "Content-Type": 'application/json'
        },
        body: answer);
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 500) {
      throw Exception();
    }
  }

  Future<ProcessActivityContentResult?> getRemoteProcessActivityContentResult(
      int processId,
      int processActivityId,
      int processActivityContentId,
      int processActivityContentCardId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/v2/1/process/$processId/activities/$processActivityId/content/$processActivityContentId/result");

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer ${accessToken?.value ?? ""}",
      "Content-Type": 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      ProcessActivityContentResult processActivityContentResult =
          ProcessActivityContentResult.fromJson(body);
      return processActivityContentResult;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw Exception();
    }
  }
}
