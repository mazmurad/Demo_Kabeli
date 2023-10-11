///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ДанныеВыделенныхСтрок") Тогда
		
		ВызватьИсключение НСтр("ru ='Самостоятельное использование формы не предусмотрено.'", ОбщегоНазначения.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	УсловноеОформлениеФормы();
	ЗаполнитьТаблицуФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ИзменитьОтметкуСтрок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	ИзменитьОтметкуСтрок(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличия(Команда)
	
	ПоказатьОтличияВерсийОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПересмотретьРезультат(Команда)
	
	ТекстВопроса = НСтр("ru = 'Пересмотреть результаты коллизий по отмеченным строкам?'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПересмотретьРезультатыКоллизий", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересмотретьРезультатыКоллизий(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыПересмотра = Новый Структура;
	ПараметрыПересмотра.Вставить("КоличествоПересмотренных", 0);
	ПараметрыПересмотра.Вставить("КоличествоВсего", 0);
	
	ПересмотретьРезультатыНаСервере(ПараметрыПересмотра);
	
	Если ПараметрыПересмотра.КоличествоПересмотренных > 0 Тогда
		
		Оповестить("ИсправлениеПредупрежденийСинхронизацииПересмотрКоллизии");
		
	КонецЕсли;
	
	ОчиститьСообщения();
	Если ПараметрыПересмотра.КоличествоПересмотренных <> ПараметрыПересмотра.КоличествоВсего Тогда
		
		ШаблонСообщения = НСтр("ru = 'Отмечено строк: %1. Изменено объектов: %2.'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
		
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения,
			Формат(ПараметрыПересмотра.КоличествоВсего, "ЧН=; ЧГ=0"),
			Формат(ПараметрыПересмотра.КоличествоПересмотренных, "ЧН=; ЧГ=0"));
		
		ПоказатьПредупреждение(Неопределено, СообщениеОбОшибке);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюЭтойПрограммы(Команда)
	
	ОткрытьВерсиюНаКлиенте("ВерсияЭтойПрограммы");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюДругойПрограммы(Команда)
	
	ОткрытьВерсиюНаКлиенте("ВерсияИзДругойПрограммы");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьОтличияВерсийОбъекта()
	
	ТекущиеДанныеСтроки = Элементы.ТаблицаОбъектовИсправления.ТекущиеДанные;
	Если ТекущиеДанныеСтроки = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	
	Если ТекущиеДанныеСтроки.ВерсияЭтойПрограммы <> 0 Тогда
		
		СравниваемыеВерсии.Добавить(ТекущиеДанныеСтроки.ВерсияЭтойПрограммы);
		
	КонецЕсли;
	
	Если ТекущиеДанныеСтроки.ВерсияИзДругойПрограммы <> 0 Тогда
		
		СравниваемыеВерсии.Добавить(ТекущиеДанныеСтроки.ВерсияИзДругойПрограммы);
		
	КонецЕсли;
	
	Если СравниваемыеВерсии.Количество() <> 2 Тогда
		
		ТекстСообщения = НСтр("ru = 'Нет версии для сравнения.'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	ОткрытьОтчетСравненияВерсий(ТекущиеДанныеСтроки.ПроблемныйОбъект, СравниваемыеВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтметкуСтрок(ЗначениеОтметки);
	
	Для Каждого ВыделеннаяСтрока Из ТаблицаОбъектовИсправления Цикл
		
		ВыделеннаяСтрока.ОбработатьСтроку = ЗначениеОтметки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюНаКлиенте(ПолеВерсия)
	
	ТекущиеДанные = Элементы.ТаблицаОбъектовИсправления.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(ТекущиеДанные[ПолеВерсия]);
	
	ОткрытьОтчетСравненияВерсий(ТекущиеДанные.ПроблемныйОбъект, СравниваемыеВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетСравненияВерсий(Ссылка, СравниваемыеВерсии)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		
		МодульВерсионированиеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВерсионированиеОбъектовКлиент");
		МодульВерсионированиеОбъектовКлиент.ОткрытьОтчетСравненияВерсий(Ссылка, СравниваемыеВерсии);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УсловноеОформлениеФормы()
	
	ОшибкиКрасным = УсловноеОформление.Элементы.Добавить();
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ОшибкиКрасным.Отбор, "ТаблицаОбъектовИсправления.НеудачнаяПопытка", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОшибкиКрасным.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноКрасный);
	
	ПолеОформления = ОшибкиКрасным.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаОбъектовИсправленияПроблемныйОбъект");
	ПолеОформления = ОшибкиКрасным.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаОбъектовИсправленияРезультатПроведения");
	ПолеОформления = ОшибкиКрасным.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаОбъектовИсправленияНеудачнаяПопытка");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуФормы()
	
	Если ТипЗнч(Параметры.ДанныеВыделенныхСтрок) <> Тип("Массив") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для каждого ДанныеСтроки Из Параметры.ДанныеВыделенныхСтрок Цикл
		
		НоваяСтрока = ТаблицаОбъектовИсправления.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
		НоваяСтрока.ОбработатьСтроку = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПересмотретьРезультатыНаСервере(ПараметрыПересмотра)
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
	ШаблонТекстаОшибки = НСтр("ru = 'Не удалось изменить версию объекта по причине:%1%2'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	Для Каждого ВыделеннаяСтрока Из ТаблицаОбъектовИсправления Цикл
		
		Если НЕ ВыделеннаяСтрока.ОбработатьСтроку Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ПараметрыПересмотра.КоличествоВсего = ПараметрыПересмотра.КоличествоВсего + 1;
		
		Попытка
			
			МодульВерсионированиеОбъектов.ПриПереходеНаВерсиюОбъекта(ВыделеннаяСтрока.ПроблемныйОбъект, ВыделеннаяСтрока.ВерсияИзДругойПрограммы);
			ПараметрыПересмотра.КоличествоПересмотренных = ПараметрыПересмотра.КоличествоПересмотренных + 1;
			
		Исключение
			
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ВыделеннаяСтрока.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаОшибки, Символы.ПС, ТекстОшибки);
			ВыделеннаяСтрока.НеудачнаяПопытка = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
