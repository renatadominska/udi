*** Settings ***
Library	SeleniumLibrary
Library	String

*** Variables ***
${url}	https://selfservice.udi.no/en-gb/applicant-start/
${username}	
${password}

*** Test Cases ***
My Test
    Open Browser	${url} 	headlesschrome
	#Maximize Browser Window
	Set Window Size    1696    1036
	Set selenium timeout	10s
	Input Text	logonIdentifier	${username}
	Input Text	password	${password}
	Click element	next
	Click element	ctl00_BodyRegion_PageRegion_MainRegion_ApplicationOverview_repApplicationOverviewLarge_ctl01_Button1
	#Click element	ctl00_BodyRegion_PageRegion_MainRegion_ApplicationOverview_applicationOverviewListView_ctrl0_btnBookAppointment
	${currentDate}=	Get text	ctl00_PageRegion_MainContentRegion_ViewControl_spnReceiptAndBooking_BookingSummaryInfo_lblDate
	${currentDateSplited}	split string	${currentDate}
	${currentDay}	get substring	${currentDateSplited}	1	2
	${currentDay}	convert to integer	${currentDay[0]}
	#Element should contain	ctl00_PageRegion_MainContentRegion_ViewControl_spnReceiptAndBooking_BookingSummaryInfo_lblDate	Tuesday 22 December 2020
	Click element	ctl00_PageRegion_MainContentRegion_ViewControl_spnReceiptAndBooking_BookingSummaryInfo_btnChangeBooking	
	#Click element	ctl00_BodyRegion_PageRegion_MainRegion_appointmentReservation_appointmentCalendar_btnNext
	#Click element	ctl00_BodyRegion_PageRegion_MainRegion_appointmentReservation_appointmentCalendar_btnNext
	${isvisible}	run keyword and return status	wait until element is visible	(//span[contains(text(),'Available appointments') or contains(text(),'Few available appointments')])[1]	timeout=15s
	run keyword if	'${isvisible}'=='False'		Pass Execution	Nie ma wolnych terminow	
	${firstFreeDay}=	Get text	(//span[contains(text(),'Available appointments') or contains(text(),'Few available appointments')])[1]/../../span[@class='dayNumber']
	${firstFreeDay}=	Convert to integer	${firstFreeDay}
	Run Keyword if	${firstFreeDay}>=${currentDay}	Pass Execution	wolny termin pozniej niz mam
	Click element	(//span[contains(text(),'Available appointments') or contains(text(),'Few available appointments')])[1]
	Select from list by index	ctl00_BodyRegion_PageRegion_MainRegion_appointmentReservation_appointmentList_ddlAppointmentTimes	1
	Click element	ctl00_BodyRegion_PageRegion_MainRegion_appointmentReservation_appointmentList_btnSelectAppointment
	
*** Keywords ***
Input Text	
	[Arguments]		${locator}	${text}
	wait until element is visible	${locator}
	wait until element is enabled	${locator}
	wait until keyword succeeds	15x	1s	SeleniumLibrary.Input Text	${locator}	${text}
	
Click Element	
	[Arguments]		${locator}	
	wait until element is visible	${locator}
	wait until element is enabled	${locator}
	wait until keyword succeeds	15x	1s	SeleniumLibrary.Click Element	${locator}
	
Element should contain
	[Arguments] 	${locator}	${expected}
	wait until element is visible	${locator}
	wait until keyword succeeds	15x	1s	SeleniumLibrary.Element should contain	${locator}	${expected}
	
Select from list by index
	[Arguments] 	${locator}	${index}
	Wait until element is visible	${locator}
	Wait until element is enabled	${locator}
	Wait until keyword succeeds	15x	1s	SeleniumLibrary.Select from list by index	${locator}	${index}
	
Get Text	
	[Arguments]		${locator}
	wait until element is visible	${locator}
	${someText}=	SeleniumLibrary.Get Text	${locator}
	[Return]	${someText}