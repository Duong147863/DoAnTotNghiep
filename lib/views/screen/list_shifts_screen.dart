import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';
import 'package:nloffice_hrm/view_models/shifts_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_shifts_screen.dart';
import 'package:nloffice_hrm/views/screen/info_shifts_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ListShiftsScreen extends StatefulWidget {
  const ListShiftsScreen({super.key});

  @override
  State<ListShiftsScreen> createState() => _ListShiftsScreenState();
}

class _ListShiftsScreenState extends State<ListShiftsScreen> {
  List<Shifts> shifts = [];
  List<Shifts> filteredShifts = [];
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredShifts = shifts;
      } else {
        filteredShifts = shifts.where((shift) {
          return shift.shiftName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _handleUpdate(Shifts updatedShift) {
    setState(() {
      int index =
          shifts.indexWhere((shi) => shi.shiftId == updatedShift.shiftId);
      if (index != -1) {
        shifts[index] = updatedShift;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddShiftsScreen(),
              ),
            );
          },
          icon: Icon(Icons.add),
        )
      ],
      appBar: AppBar(
        backgroundColor: Color(0xFF0B258A),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quản lí ca làm việc",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFEFF8FF),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
      bodyChildren: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            hintText: '',
            suggestions: shifts.map((shift) => shift.shiftName!).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child:
              Consumer<ShiftsViewModel>(builder: (context, viewModel, child) {
            if (!viewModel.fetchingData && viewModel.listShifts.isEmpty) {
              Provider.of<ShiftsViewModel>(context, listen: false)
                  .getAllShifts();
            }
            if (viewModel.fetchingData) {
              // While data is being fetched
              return Center(child: CircularProgressIndicator());
            } else {
              // If data is successfully fetched
              List<Shifts> shifts = viewModel.listShifts;
              return CustomListView(
                dataSet: shifts,
                itemBuilder: (context, index) {
                  return CustomCard(
                          title: Text(
                              "${shifts[index].shiftId} - ${shifts[index].shiftName}"),
                          subttile: Text(
                              "${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(shifts[index].startTime))} - ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(shifts[index].endTime))}"))
                      .onInkTap(
                    () async {
                      final updatedShift = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShiftInfoScreen(shifts: shifts[index]),
                        ),
                      );
                      // Kiểm tra xem có dữ liệu cập nhật không
                      if (updatedShift != null) {
                        _handleUpdate(updatedShift);
                      }
                    },
                  ).px8();
                },
              );
            }
          }),
        ),
      ],
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddShiftsScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
