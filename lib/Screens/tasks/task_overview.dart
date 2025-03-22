import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techqrmaintance/Screens/tasks/widgets/completiondetails.dart';
import 'package:techqrmaintance/Screens/tasks/widgets/customer_info.dart';
import 'package:techqrmaintance/Screens/tasks/widgets/device_info.dart';
import 'package:techqrmaintance/Screens/tasks/widgets/main_info.dart';
import 'package:techqrmaintance/Screens/tasks/widgets/main_timeline.dart';
import 'package:techqrmaintance/Screens/tasks/widgets/status_bar_wid.dart';
import 'package:techqrmaintance/application/servicereqbyidbloc/service_req_by_id_bloc.dart';
import 'package:techqrmaintance/core/colors.dart';

class TaskOverviewScreen extends StatelessWidget {
  final String? currentUserId;
  const TaskOverviewScreen({
    super.key,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceReqByIdBloc>().add(
            ServiceReqByIdEvent.getservicebyid(id: currentUserId!),
          );
    });
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          "Task Overview",
          style: TextStyle(
              color: primaryBlue, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: primaryWhite,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: primaryTransparent,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implement navigation to edit screen
              },
              child: const Text('Edit Task'),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ServiceReqByIdBloc, ServiceReqByIdState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
            ),
            child: ListView(
              children: [
                StatusBarWidget(
                  status: state.servicesModel.status,
                  taskNumber: state.servicesModel.id.toString(),
                ),
                const SizedBox(height: 16),
                MainInfo(
                  jobType: state.servicesModel.jobType.toString(),
                  jobIssue: state.servicesModel.selectedIssue,
                  jobDescription:
                      state.servicesModel.issueDescription.toString(),
                ),
                const SizedBox(height: 16),
                BuildTimelineMain(
                  created: state.servicesModel.createdAt,
                  started: state.servicesModel.startedAt,
                  completed: state.servicesModel.completedAt,
                  preferred: state.servicesModel.preferredTimeslot,
                ),
                const SizedBox(height: 16),
                Deviceinfo(
                  catagory: state.servicesModel.device?.category?.name,
                  serialNumber: state.servicesModel.device?.serialNumber,
                  installation: state.servicesModel.device?.installationDate,
                  warranty:
                      state.servicesModel.device?.warrantyPeriod.toString(),
                  freeMaintenance:
                      state.servicesModel.device?.freeMaintenance.toString(),
                  location: state.servicesModel.device?.locationDetails,
                ),
                const SizedBox(height: 16),
                CustomerInfo(
                  name: state.servicesModel.customer?.fullName,
                  phone: state.servicesModel.customer?.phone,
                  email: state.servicesModel.customer?.email,
                  address: state.servicesModel.customer?.address,
                  gpsCoordinates: state.servicesModel.customer?.gpsCoordinates,
                ),
                const SizedBox(height: 16),
                state.servicesModel.status != "Completed"
                    ? SizedBox.shrink()
                    : CompletionDetailes(
                        notes: state.servicesModel.completionNotes,
                        partsUsed: state.servicesModel.newPartsUsed,
                        completionPhotoUrl:
                            state.servicesModel.completionPhotoUrl,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
