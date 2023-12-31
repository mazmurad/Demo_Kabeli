
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("СписокВыбранныхКабельныхЛиний") Тогда  
		ПрочитатьКабельныеЛинииПоФормеВладелец();
	КонецЕсли;		
	
КонецПроцедуры
#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыКабельныеЛинии
&НаКлиенте
Процедура КабельныеЛинииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если КабельнаяЛинияВыбрана(ВыбраннаяСтрока) Или ЭтоГруппаЖурналКабельнойПродукции(ВыбраннаяСтрока) Тогда
		Возврат;	
	КонецЕсли;
	
	ВыбранныеКабельныеЛинии.Добавить(ВыбраннаяСтрока, ВыбраннаяСтрока);
	
КонецПроцедуры 

&НаКлиенте
Процедура КабельныеЛинииПриАктивизацииСтроки(Элемент)
	
	ВыделенныеКабельныеЛинии = Элемент.ВыделенныеСтроки;	
	Если ВыделенныеКабельныеЛинии = Неопределено Или ВыделенныеКабельныеЛинии.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	ВыделитьКабельныеЛинииСредиВыбранных(ВыделенныеКабельныеЛинии);	
	
КонецПроцедуры
#КонецОбласти


#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ВыбратьКабельныеЛинии(Команда)
	
	ОповеститьОВыборе(ВыбранныеКабельныеЛинии.ВыгрузитьЗначения());			
	
КонецПроцедуры
#КонецОбласти


#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ПрочитатьКабельныеЛинииПоФормеВладелец()

	СписокВыбранныхКабЛиний = Параметры.СписокВыбранныхКабельныхЛиний;		
	
	Для Каждого ТекКабЛиния Из СписокВыбранныхКабЛиний Цикл
		ВыбранныеКабельныеЛинии.Добавить(ТекКабЛиния, ТекКабЛиния);	
	КонецЦикла;		
	
КонецПроцедуры

&НаКлиенте
Функция КабельнаяЛинияВыбрана(ВыбраннаяСтрока)
	
	Возврат ВыбранныеКабельныеЛинии.НайтиПоЗначению(ВыбраннаяСтрока) <> Неопределено;	
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоГруппаЖурналКабельнойПродукции(Значение)

	Возврат ТипЗнч(Значение) = Тип("СтрокаГруппировкиДинамическогоСписка");
	
КонецФункции

&НаКлиенте
Процедура ВыделитьКабельныеЛинииСредиВыбранных(ВыделенныеКабельныеЛинии)
	
	Элементы.ВыбранныеКабельныеЛинии.ВыделенныеСтроки.Очистить();
	
	Для Каждого ТекКабЛиния Из ВыделенныеКабельныеЛинии Цикл
		
		Если ЭтоГруппаЖурналКабельнойПродукции(ТекКабЛиния) Тогда
			Продолжить;	
		КонецЕсли;	   
		
		СтрокаВыбраннаяКабЛиния = ВыбранныеКабельныеЛинии.НайтиПоЗначению(ТекКабЛиния);	
		Если СтрокаВыбраннаяКабЛиния = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		ИдентификаторВыбраннаяКабЛиния = СтрокаВыбраннаяКабЛиния.ПолучитьИдентификатор();	
		Элементы.ВыбранныеКабельныеЛинии.ВыделенныеСтроки.Добавить(ИдентификаторВыбраннаяКабЛиния);
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти
