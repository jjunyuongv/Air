<%@ page contentType="text/javascript; charset=UTF-8" %>

<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var eventModal = new bootstrap.Modal(document.getElementById('eventModal'));
    var eventForm = document.getElementById('eventForm');
    var currentEvent = null;

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        editable: true,
        selectable: true,
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        events: '/api/schedules',
        select: function(info) {
            currentEvent = null;
            document.getElementById('eventId').value = '';
            document.getElementById('eventTitle').value = '';
            document.getElementById('eventStartDate').value = moment(info.startStr).format('YYYY-MM-DDTHH:mm');
            let defaultEndTime = moment(info.startStr).add(1, 'hours').format('YYYY-MM-DDTHH:mm');
            if (info.allDay) {
                document.getElementById('eventEndDate').value = '';
                document.getElementById('eventEndDate').setAttribute('disabled', 'disabled');
            } else {
                document.getElementById('eventEndDate').value = info.endStr ? moment(info.endStr).format('YYYY-MM-DDTHH:mm') : defaultEndTime;
                document.getElementById('eventEndDate').removeAttribute('disabled');
            }
            document.getElementById('allDayEvent').checked = info.allDay;
            document.getElementById('eventLocation').value = '';
            document.getElementById('isRecurringEvent').checked = false;
            document.getElementById('eventModalLabel').innerText = '새 일정 추가';
            document.getElementById('deleteEventBtn').style.display = 'none';
            eventModal.show();
        },
        eventClick: function(info) {
            currentEvent = info.event;
            document.getElementById('eventId').value = info.event.id;
            document.getElementById('eventTitle').value = info.event.title;
            document.getElementById('eventStartDate').value = moment(info.event.start).format('YYYY-MM-DDTHH:mm');
            document.getElementById('eventEndDate').value = info.event.end ? moment(info.event.end).format('YYYY-MM-DDTHH:mm') : '';
            document.getElementById('allDayEvent').checked = info.event.allDay;
            if (info.event.allDay) {
                document.getElementById('eventEndDate').setAttribute('disabled', 'disabled');
            } else {
                document.getElementById('eventEndDate').removeAttribute('disabled');
            }
            document.getElementById('eventLocation').value = info.event.extendedProps.location || '';
            document.getElementById('isRecurringEvent').checked = info.event.extendedProps.isRecurring;
            document.getElementById('eventModalLabel').innerText = '일정 상세/수정';
            document.getElementById('deleteEventBtn').style.display = 'inline-block';
            eventModal.show();
        },
        eventDrop: function(info) {
            updateScheduleOnServer(info.event);
        },
        eventResize: function(info) {
            updateScheduleOnServer(info.event);
        }
    });

    calendar.render();

    document.getElementById('saveEventBtn').addEventListener('click', function() {
        var scheduleId = document.getElementById('eventId').value;
        var title = document.getElementById('eventTitle').value;
        var startTime = document.getElementById('eventStartDate').value;
        var endTime = document.getElementById('eventEndDate').value;
        var allDay = document.getElementById('allDayEvent').checked;
        var location = document.getElementById('eventLocation').value;
        var isRecurring = document.getElementById('isRecurringEvent').checked ? "Y" : "N";
        var userId = document.getElementById('eventUserId').value;

        if (!title || !startTime) {
            alert('제목과 시작일시는 필수입니다.');
            return;
        }

        if (allDay) endTime = null;

        var scheduleData = {
            scheduleId: scheduleId ? Number(scheduleId) : null,   
            userId: userId,
            title: title,
            startTime: startTime,
            endTime: endTime,
            location: location,
            isRecurring: isRecurring
        };

        $.ajax({
            url: '/api/schedules',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(scheduleData),
            success: function(response) {
                calendar.refetchEvents();
                eventModal.hide();
                alert(scheduleId ? '일정이 수정되었습니다.' : '일정이 추가되었습니다.');
            },
            error: function(xhr, status, error) {
                console.error('일정 저장 실패:', error);
                alert('일정 저장에 실패했습니다.');
            }
        });
    });


    document.getElementById('deleteEventBtn').addEventListener('click', function() {
        var scheduleId = document.getElementById('eventId').value;
        if (!scheduleId) return;
        if (confirm('정말 삭제하시겠습니까?')) {
            $.ajax({
                url: '/api/schedules/' + scheduleId,
                type: 'DELETE',
                success: function() {
                    if (currentEvent) currentEvent.remove();
                    eventModal.hide();
                    alert('삭제 완료');
                },
                error: function() {
                    alert('삭제 실패');
                }
            });
        }
    });

    function updateScheduleOnServer(event) {
        var scheduleData = {
            scheduleId: event.id,
            userId: event.extendedProps.userId || document.getElementById('eventUserId').value,
            title: event.title,
            startTime: moment(event.start).format('YYYY-MM-DDTHH:mm'),
            endTime: event.end ? moment(event.end).format('YYYY-MM-DDTHH:mm') : null,
            location: event.extendedProps.location || "",
            isRecurring: event.extendedProps.isRecurring ? "Y" : "N"
        };

        $.ajax({
            url: '/api/schedules',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(scheduleData),
            success: function() {
                calendar.refetchEvents();
            },
            error: function() {
                alert('일정 수정 실패');
                calendar.refetchEvents();
            }
        });
    }

    document.getElementById('allDayEvent').addEventListener('change', function() {
        var endDateInput = document.getElementById('eventEndDate');
        if (this.checked) {
            endDateInput.setAttribute('disabled', 'disabled');
            endDateInput.value = '';
        } else {
            endDateInput.removeAttribute('disabled');
            if (!endDateInput.value && document.getElementById('eventStartDate').value) {
                endDateInput.value = moment(document.getElementById('eventStartDate').value).add(1, 'hours').format('YYYY-MM-DDTHH:mm');
            }
        }
    });

    document.getElementById('eventModal').addEventListener('hidden.bs.modal', function () {
        eventForm.reset();
        document.getElementById('deleteEventBtn').style.display = 'none';
        document.getElementById('eventEndDate').removeAttribute('disabled');
    });
});
</script>
