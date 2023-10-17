import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/screens/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final String description;
  final int status;
  final DateTime date;

  Event(this.title, this.description, this.status, this.date);

  @override
  String toString() => title;
}

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Map<DateTime, List<Event>> _eventsByDate = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier<List<Event>>([]);
    _loadEventsForDays(kFirstDay, kLastDay);

    _loadEventsForDay(_selectedDay!);
  }

  Future<void> _loadEventsForDays(DateTime start, DateTime end) async {
    for (var day = start; day.isBefore(end) || day.isAtSameMomentAs(end); day = day.add(const Duration(days: 1))) {
      await _loadEventsForDay(day);
    }
  }

  Future<void> _loadEventsForDay(DateTime day) async {
    String formattedDate = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    List<TaskModel> tasks = await AgendaDB().getTareasExpiracion(formattedDate);
    List<Event> events = tasks.map((task) => Event(task.nomTask!, task.desTask!, task.realizada!, day)).toList();
    _eventsByDate[day] = events;
    if (isSameDay(day, _selectedDay)) {
      _selectedEvents.value = events;
    }
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final events = <Event>[];

    for (var day = start; day.isBefore(end) || day.isAtSameMomentAs(end); day = day.add(const Duration(days: 1))) {
      if (_eventsByDate.containsKey(day)) {
        events.addAll(_eventsByDate[day]!);
      }
    }

    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _eventsByDate[selectedDay] ?? [];
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _eventsByDate[start] ?? [];
    } else if (end != null) {
      _selectedEvents.value = _eventsByDate[end] ?? [];
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pendiente';
      case 1:
        return 'Completada';
      default:
        return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _loadEventsForDays(_focusedDay.subtract(const Duration(days: 15)), _focusedDay.add(const Duration(days: 15)));
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadEventsForDays(focusedDay.subtract(const Duration(days: 15)), focusedDay.add(const Duration(days: 15)));
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            eventLoader: (day) => _eventsByDate[day] ?? [],
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                        subtitle: Text('${value[index].description}'),
                        trailing: Text('${getStatusText(value[index].status)}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}