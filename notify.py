#!/usr/bin/python3
# -*- coding: utf-8 -*-

from gi.repository import Notify

Notify.init("meh");

low_battery_notification = Notify.Notification()
low_battery_notification.set_urgency(Notify.Urgency.CRITICAL)
low_battery_notification.add_action("hibernate", "Hibernate now", lambda x: x)

low_battery_notification.update(
	"Low battery (5%)",
	"The system will hibernate shortly.",
	"battery-low"
)

low_battery_notification.show()
