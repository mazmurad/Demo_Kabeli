///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Параметры формы:
//   СоставТабличногоВопроса - ДанныеФормыКоллекция - с колонками:
//    * ЭлементарныйВопрос - ПланВидовХарактеристикСсылка.ВопросыДляАнкетирования
//    * НомерСтроки - Число
//

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УправлениеДоступностью();
	УстановитьИнформационныеНадписи();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим список выбора для типа табличного вопроса.
	Для каждого ЭлементМетаданных Из Метаданные.Перечисления.ТипыТабличныхВопросов.ЗначенияПеречисления Цикл
		Элементы.ТипТабличногоВопроса.СписокВыбора.Добавить(Перечисления.ТипыТабличныхВопросов[ЭлементМетаданных.Имя],ЭлементМетаданных.Синоним);
	КонецЦикла;
		
	// Примем параметры формы владельца.
	ОбработатьПараметрыФормыВладельца();
	
	// Установим страницу
	Если Параметры.ТипТабличногоВопроса = Перечисления.ТипыТабличныхВопросов.ПустаяСсылка() Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаТипТабличногоВопроса;
	Иначе
		СформироватьРезультирующуюТаблицу();
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультирующаяТаблица;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ВыполняетсяЗакрытие И ЭтоНоваяСтрока Тогда
		Оповестить("ОтменаВводаНовойСтрокиШаблонаАнкеты");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипТабличногоВопросаПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросыВопросОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыВопрос = РеквизитыВопроса(ВыбранноеЗначение);
	Если РеквизитыВопрос.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = Вопросы.НайтиПоИдентификатору(Элементы.Вопросы.ТекущаяСтрока);
	ТекЭлемент.ЭлементарныйВопрос = ВыбранноеЗначение;
	
	ТекЭлемент.Представление = РеквизитыВопрос.Представление;
	ТекЭлемент.Формулировка  = РеквизитыВопрос.Формулировка;
	ТекЭлемент.ТипОтвета     = РеквизитыВопрос.ТипОтвета;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыСтрокиОтветыВСтрокахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	НоваяСтрока = ДобавлениеОтветаИнтерактивно(Элемент,Копирование,0);
	ОбработатьЭлементПодбораОтветовПослеДобавления(Элемент,НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыКолонкиОтветыВКолонкахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	НоваяСтрока = ДобавлениеОтветаИнтерактивно(Элемент,Копирование,0);
	ОбработатьЭлементПодбораОтветовПослеДобавления(Элемент,НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыКолонкиОтветыВСтрокахИКолонкахОтветНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСписков(Элемент,СтандартнаяОбработка, ТипЗначенияВопроса(ВопросДляКолонок));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыСтрокиОтветыВСтрокахОтветНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСписков(Элемент,СтандартнаяОбработка, ТипЗначенияВопроса(ВопросДляСтрок));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыСтрокиОтветыВСтрокахИКолонкахОтветНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСписков(Элемент,СтандартнаяОбработка, ТипЗначенияВопроса(ВопросДляСтрок));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыКолонкиОтветыВКолонкахОтветНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСписков(Элемент,СтандартнаяОбработка, ТипЗначенияВопроса(ВопросДляКолонок));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыКолонкиОтветыВСтрокахИКолонкахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	НоваяСтрока = ДобавлениеОтветаИнтерактивно(Элемент,Копирование,1);
	ОбработатьЭлементПодбораОтветовПослеДобавления(Элемент,НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыСтрокиОтветыВСтрокахИКолонкахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	НоваяСтрока = ДобавлениеОтветаИнтерактивно(Элемент,Копирование,0);
	ОбработатьЭлементПодбораОтветовПослеДобавления(Элемент,НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросыПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыКолонкиОтветыВСтрокахИКолонкахПриИзменении(Элемент)
	
	ПриИзмененииОтветов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыСтрокиОтветыВСтрокахИКолонкахПриИзменении(Элемент)
	
	ПриИзмененииОтветов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыКолонкиОтветыВКолонкахПриИзменении(Элемент)
	
	ПриИзмененииОтветов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветыСтрокиОтветыВСтрокахПриИзменении(Элемент)
	
	ПриИзмененииОтветов(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормулировкаПриИзменении(Элемент)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультирующаяТаблица Тогда
		
		Элементы.КнопкаВперед.Доступность 	= ЗначениеЗаполнено(Формулировка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СледующаяСтраница(Команда)
	
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.СтраницаТипТабличногоВопроса Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы;
		
	ИначеЕсли (ТекущаяСтраница = Элементы.СтраницаВопросы) И (ТипТабличногоВопроса <> ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.Составной")) Тогда
		
		УстановитьСтраницуОтветы();
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаРезультирующаяТаблица Тогда
		
		ЗакончитьРедактированиеИЗакрыть();
		
	Иначе
		
		СформироватьРезультирующуюТаблицу();
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультирующаяТаблица;
		
	КонецЕсли;
	
	УправлениеДоступностью();
	УстановитьИнформационныеНадписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущаяСтраница(Команда)

	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультирующаяТаблица Тогда
		
		Если ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.Составной") Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы;
		Иначе
			УстановитьСтраницуОтветы();
		КонецЕсли;
		
		Элементы.КнопкаВперед.Заголовок = НСтр("ru = 'Далее'") + ">";
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаТипТабличногоВопроса;
		
	Иначе 
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВопросы;
		
	КонецЕсли;
	
	УправлениеДоступностью();
	УстановитьИнформационныеНадписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВариантыОтветовОтветыВСтроках(Команда)
	
	ОчиститьЗаполнитьВариантыОтветов(ВопросДляСтрок);
	УстановитьОтборы();
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВариантыОтветовОтветыВКолонках(Команда)
	
	ОчиститьЗаполнитьВариантыОтветов(ВопросДляКолонок);
	УстановитьОтборы();
	УправлениеДоступностью();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТипЗначенияВопроса(Вопрос)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Вопрос,"ТипЗначения");
КонецФункции

&НаКлиенте
Процедура УстановитьИнформационныеНадписи()
	
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.СтраницаРезультирующаяТаблица Тогда
		ИнформацияШапка                 = НСтр("ru = 'Результирующая таблица:'");
		ИнформацияПодвал                = НСтр("ru = 'Нажмите Готово для окончания редактирования.'");
		Элементы.КнопкаВперед.Заголовок = НСтр("ru = 'Готово'");
	Иначе
		Элементы.КнопкаВперед.Заголовок = НСтр("ru = 'Далее>>'");
		Если ТекущаяСтраница = Элементы.СтраницаВопросы Тогда
			Если ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.Составной") Тогда
				ИнформацияШапка  = НСтр("ru = 'Подбор вопросов. Укажите хотя бы один вопрос:'");
				ИнформацияПодвал = НСтр("ru = 'Нажмите Далее для просмотра получившейся таблицы.'");
			ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтрокахИКолонках") Тогда
				ИнформацияШапка  =НСтр("ru = 'Подбор вопросов. Укажите три вопроса:'");
				ИнформацияПодвал =НСтр("ru = 'Нажмите Далее для подбора предопределенных ответов.'");
			Иначе
				ИнформацияШапка   =НСтр("ru = 'Подбор вопросов. Укажите как минимум два вопроса:'");
				ИнформацияПодвал  =НСтр("ru = 'Нажмите Далее для подбора предопределенных ответов.'");
			КонецЕсли;
		ИначеЕсли ТекущаяСтраница = Элементы.СтраницаТипТабличногоВопроса Тогда
			ИнформацияШапка       = НСтр("ru = 'Выбор типа табличного вопроса:'");
			ИнформацияПодвал      = НСтр("ru = 'Нажмите Далее для подбора вопросов:'");
		Иначе
			ИнформацияШапка  = НСтр("ru = 'Подбор предопределенных ответов:'");
			ИнформацияПодвал = НСтр("ru = 'Нажмите Далее для просмотра получившейся таблицы:'");
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаОсновныеСтраницы.Заголовок = ИнформацияШапка;
	
КонецПроцедуры

// Управляет доступностью реквизитов формы.
&НаКлиенте
Процедура УправлениеДоступностью()

	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Элементы.КнопкаНазад.Доступность 	= (НЕ ТекущаяСтраница = Элементы.СтраницаТипТабличногоВопроса);
		
	Если ТекущаяСтраница = Элементы.СтраницаПредопределенныеОтветыВСтрокахИКолонках Тогда
		 		
		Если НЕ ВсеОтветыЗаполнены() Тогда
			Элементы.КнопкаВперед.Доступность = Ложь;
			Возврат;
		КонецЕсли;			
		
		Элементы.ЗаполнитьКолонкиВариантыОтветовОтветыСтрокахИКолонках.Доступность = (Вопросы[1].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.НесколькоВариантовИз") 
		                                                                             Или Вопросы[1].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ОдинВариантИз"));
		
		Элементы.ЗаполнитьСтрокиВариантыОтветовОтветыСтрокиИКолонки.Доступность    = (Вопросы[0].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.НесколькоВариантовИз") 
		                                                                             Или Вопросы[0].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ОдинВариантИз"));
		
		Если Ответы.НайтиСтроки(Новый Структура("ЭлементарныйВопрос",ВопросДляКолонок)).Количество() > 0 
			И Ответы.НайтиСтроки(Новый Структура("ЭлементарныйВопрос",ВопросДляСтрок)).Количество() > 0  Тогда
			
			Элементы.КнопкаВперед.Доступность = Истина;
			
		Иначе
			
			Элементы.КнопкаВперед.Доступность = Ложь;
			
		КонецЕсли;	
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаПредопределенныеОтветыВСтроках Тогда
		
		Элементы.ЗаполнитьВариантыОтветовОтветыСтроки.Доступность = (Вопросы[0].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.НесколькоВариантовИз") 
		                                                             Или Вопросы[0].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ОдинВариантИз"));
		
		Если НЕ ВсеОтветыЗаполнены() Тогда
			Элементы.КнопкаВперед.Доступность = Ложь;
			Возврат;
		КонецЕсли;
		
		Элементы.КнопкаВперед.Доступность = (Ответы.НайтиСтроки(Новый Структура("ЭлементарныйВопрос",ВопросДляСтрок)).Количество() > 0);
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаПредопределенныеОтветыВКолонках Тогда
		
		Элементы.ЗаполнитьВариантыОтветовОтветыКолонки.Доступность = (Вопросы[0].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.НесколькоВариантовИз") 
		                                                             Или Вопросы[0].ТипОтвета = ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.ОдинВариантИз"));
		
		Если НЕ ВсеОтветыЗаполнены() Тогда
			Элементы.КнопкаВперед.Доступность = Ложь;
			Возврат;
		КонецЕсли;
		
		Элементы.КнопкаВперед.Доступность = (Ответы.НайтиСтроки(Новый Структура("ЭлементарныйВопрос",ВопросДляКолонок)).Количество() > 0);
	
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаТипТабличногоВопроса Тогда
				
		Элементы.КнопкаВперед.Доступность 	= ТипТабличногоВопроса <> ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПустаяСсылка");
				
		Если ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.Составной") Тогда
			
			Элементы.СтраницыТипТабличногоВопросаКартинки.ТекущаяСтраница = Элементы.СтраницаКартинкаСоставной;
			
		ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтроках") Тогда
			
			Элементы.СтраницыТипТабличногоВопросаКартинки.ТекущаяСтраница = Элементы.СтраницаКартинкаОтветыВСтроках;
	
		ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВКолонках") Тогда
			
			Элементы.СтраницыТипТабличногоВопросаКартинки.ТекущаяСтраница = Элементы.СтраницаКартинкаОтветыВКолонках;
			
		ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтрокахИКолонках") Тогда
			
			Элементы.СтраницыТипТабличногоВопросаКартинки.ТекущаяСтраница = Элементы.СтраницаКартинкаОтветыВСтрокахИКолонках;
			
		Иначе
			
			Элементы.СтраницыТипТабличногоВопросаКартинки.ТекущаяСтраница = Элементы.СтраницаКартинкаПустая;
			
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаВопросы Тогда
		
		Если Вопросы.НайтиСтроки(Новый Структура("ЭлементарныйВопрос",ПредопределенноеЗначение("ПланВидовХарактеристик.ВопросыДляАнкетирования.ПустаяСсылка"))).Количество() <> 0  Тогда
			Элементы.КнопкаВперед.Доступность = Ложь;
			Возврат;
		КонецЕсли;
		
		Если ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.Составной") Тогда
			
			Элементы.КнопкаВперед.Доступность = (Вопросы.Количество() > 0); 
			
		ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтроках") Тогда
			
			Элементы.КнопкаВперед.Доступность = (Вопросы.Количество() > 1);
			
		ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВКолонках") Тогда
			
			Элементы.КнопкаВперед.Доступность = (Вопросы.Количество() > 1);
			
		ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтрокахИКолонках") Тогда
			
			Элементы.КнопкаВперед.Доступность = (Вопросы.Количество() = 3);
			
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаРезультирующаяТаблица Тогда
		
		Элементы.КнопкаВперед.Доступность =  ЗначениеЗаполнено(Формулировка);
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, все ли ответы заполнены.
//
// Возвращаемое значение:
//   Булево   - Истина если все ответы заполнены.
//
&НаКлиенте
Функция ВсеОтветыЗаполнены()

	Для каждого Ответ Из Ответы Цикл
	
		Если НЕ ЗначениеЗаполнено(Ответ.Ответ) Тогда
			Возврат  Ложь;
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Истина;

КонецФункции

// Процедура обрабатывает начало выбора из списков, и устанавливает отборы в формах выбора.
&НаКлиенте
Процедура НачалоВыбораСписков(Элемент,СтандартнаяОбработка,ОписаниеДоступныхТипов)
	
	Если ТипЗнч(ЭтотОбъект[Элемент.СвязьПоТипу.ПутьКДанным]) = Тип("ПланВидовХарактеристикСсылка.ВопросыДляАнкетирования") Тогда
		
		Если ОписаниеДоступныхТипов.СодержитТип(Тип("СправочникСсылка.ВариантыОтветовАнкет")) И (ОписаниеДоступныхТипов.Типы().Количество() = 1 ) Тогда
			
			СтандартнаяОбработка = ЛОЖЬ;
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Владелец", ЭтотОбъект[Элемент.СвязьПоТипу.ПутьКДанным]);
			ПараметрыОтбора.Вставить("ПометкаУдаления", Ложь);
			ОткрытьФорму("Справочник.ВариантыОтветовАнкет.ФормаВыбора", Новый Структура("Отбор",ПараметрыОтбора),Элемент);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура очищает таблицу ответов, от ответов, родительский вопрос которых
// не входит в МассивВопросов, выступающий в качестве параметра.
//
&НаКлиенте
Процедура ОчиститьСписокОтветовЕслиНеобходимо(МассивВопросов)
	
	УдаляемыеОтветы = Новый Массив;
	
	Для каждого Ответ Из Ответы Цикл
		
		Если МассивВопросов.Найти(Ответ.ЭлементарныйВопрос) = Неопределено Тогда
			 УдаляемыеОтветы.Добавить(Ответ);
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого УдаляемыйОтвет Из УдаляемыеОтветы Цикл
		Ответы.Удалить(УдаляемыйОтвет);
	КонецЦикла;
	
КонецПроцедуры 

// Устанавливает нужную страницу формирования структуры табличного вопроса в зависимости от
// выбранного типа табличного вопроса.
//
&НаКлиенте
Процедура УстановитьСтраницуОтветы()
	
	МассивВопросовДляКоторыйДолжныБытьОтветы = Новый Массив;
	
	Если ТипТабличногоВопроса =  ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтрокахИКолонках") Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПредопределенныеОтветыВСтрокахИКолонках;
		ПредставлениеВопросаДляСтрок      = Вопросы[0].Формулировка;
		ВопросДляСтрок                    = Вопросы[0].ЭлементарныйВопрос;
		ПредставлениеВопросаДляКолонок    = Вопросы[1].Формулировка;
		ВопросДляКолонок                  = Вопросы[1].ЭлементарныйВопрос;
		
		МассивВопросовДляКоторыйДолжныБытьОтветы.Добавить(ВопросДляСтрок);
		МассивВопросовДляКоторыйДолжныБытьОтветы.Добавить(ВопросДляКолонок);
		
	ИначеЕсли ТипТабличногоВопроса =  ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтроках") Тогда 
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПредопределенныеОтветыВСтроках;
		ПредставлениеВопросаДляСтрок      = Вопросы[0].Формулировка;
		ВопросДляСтрок                    = Вопросы[0].ЭлементарныйВопрос;
		
		МассивВопросовДляКоторыйДолжныБытьОтветы.Добавить(ВопросДляСтрок);
		
	ИначеЕсли ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВКолонках") Тогда 
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПредопределенныеОтветыВКолонках;
		ПредставлениеВопросаДляКолонок    = Вопросы[0].Формулировка;
		ВопросДляКолонок                  = Вопросы[0].ЭлементарныйВопрос;
		
		МассивВопросовДляКоторыйДолжныБытьОтветы.Добавить(ВопросДляКолонок);
		
	КонецЕсли;
	
	ОчиститьСписокОтветовЕслиНеобходимо(МассивВопросовДляКоторыйДолжныБытьОтветы);
	УстановитьОтборы();
	
КонецПроцедуры

// Формирует результирующую таблицу вопроса.
&НаСервере
Процедура СформироватьРезультирующуюТаблицу()
	
	Анкетирование.ОбновитьПревьюТабличныйВопрос(РеквизитФормыВЗначение("Вопросы"),Ответы,ТипТабличногоВопроса,ЭтотОбъект,"РезультирующаяТаблица","");
	Элементы.КнопкаВперед.Заголовок = НСтр("ru = 'Готово'");
	
КонецПроцедуры

// Формирует структуру возврата для передачи в форму владельца.
&НаКлиенте
Функция СформироватьСтруктуруПараметровДляПередачиВладельцу()

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТипТабличногоВопроса",ТипТабличногоВопроса);
	
	ВопросыКВозврату = Новый Массив;
	Для каждого СтрокаТаблицы Из Вопросы Цикл
		ВопросыКВозврату.Добавить(СтрокаТаблицы.ЭлементарныйВопрос);
	КонецЦикла;
	СтруктураПараметров.Вставить("Вопросы",ВопросыКВозврату);
	СтруктураПараметров.Вставить("Ответы" ,Ответы);
	СтруктураПараметров.Вставить("Формулировка",Формулировка);
	СтруктураПараметров.Вставить("Подсказка",Подсказка);
	СтруктураПараметров.Вставить("СпособОтображенияПодсказки",СпособОтображенияПодсказки);

	Возврат СтруктураПараметров;

КонецФункции

// Обрабатывает параметры формы владельца.
//
&НаСервере
Процедура ОбработатьПараметрыФормыВладельца()
	
	Формулировка               = Параметры.Формулировка;
	Подсказка                  = Параметры.Подсказка;
	СпособОтображенияПодсказки = Параметры.СпособОтображенияПодсказки;
	ЭтоНоваяСтрока             = Параметры.ЭтоНоваяСтрока;
	
	Если Параметры.ТипТабличногоВопроса.Пустая() Тогда
		ТипТабличногоВопроса = Перечисления.ТипыТабличныхВопросов.Составной;
		Возврат;
	КонецЕсли;
	
	ТипТабличногоВопроса = Параметры.ТипТабличногоВопроса;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Вопросы.ЭлементарныйВопрос,
	|	Вопросы.НомерСтроки
	|ПОМЕСТИТЬ ЭлементарныеВопросы
	|ИЗ
	|	&Вопросы КАК Вопросы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭлементарныеВопросы.ЭлементарныйВопрос КАК ЭлементарныйВопрос,
	|	ЕСТЬNULL(ВопросыДляАнкетирования.Представление, """""""") КАК Представление,
	|	ЕСТЬNULL(ВопросыДляАнкетирования.Формулировка, """""""") КАК Формулировка,
	|	ЕСТЬNULL(ВопросыДляАнкетирования.ТипОтвета, """") КАК ТипОтвета
	|ИЗ
	|	ЭлементарныеВопросы КАК ЭлементарныеВопросы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ВопросыДляАнкетирования КАК ВопросыДляАнкетирования
	|		ПО ЭлементарныеВопросы.ЭлементарныйВопрос = ВопросыДляАнкетирования.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭлементарныеВопросы.НомерСтроки";
	
	Запрос.УстановитьПараметр("Вопросы", Параметры.СоставТабличногоВопроса.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда;
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Вопросы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Параметры.ПредопределенныеОтветы, Ответы);
	
КонецПроцедуры

// Устанавливает отборы в элементы форм, предназначенные для
// составления списка предопределенных ответов.
//
&НаКлиенте
Процедура УстановитьОтборы()
	
	Если ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтрокахИКолонках") Тогда
		
		Элементы.ОтветыКолонкиОтветыВСтрокахИКолонках.ОтборСтрок = Новый ФиксированнаяСтруктура("ЭлементарныйВопрос",ВопросДляКолонок);
		Элементы.ОтветыСтрокиОтветыВСтрокахИКолонках.ОтборСтрок  = Новый ФиксированнаяСтруктура("ЭлементарныйВопрос",ВопросДляСтрок);
		УстановитьСвязиПараметровВыбораОтветовИВопросов();
		
	ИначеЕсли ТипТабличногоВопроса =  ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтроках") Тогда
		
		Элементы.ОтветыСтрокиОтветыВСтроках.ОтборСтрок = Новый ФиксированнаяСтруктура("ЭлементарныйВопрос",ВопросДляСтрок);
		УстановитьСвязиПараметровВыбораОтветовИВопросов();
		
	ИначеЕсли ТипТабличногоВопроса =  ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВКолонках") Тогда
		
		Элементы.ОтветыКолонкиОтветыВКолонках.ОтборСтрок = Новый ФиксированнаяСтруктура("ЭлементарныйВопрос",ВопросДляКолонок);
		УстановитьСвязиПараметровВыбораОтветовИВопросов();
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвязиПараметровВыбораОтветовИВопросов()

	Если ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтрокахИКолонках") Тогда
		
		УстановитьСвязьПараметраВыбораОтветаИВопроса("ОтветыКолонкиОтветыВСтрокахИКолонкахОтвет", "ВопросДляКолонок");
		УстановитьСвязьПараметраВыбораОтветаИВопроса("ОтветыСтрокиОтветыВСтрокахИКолонкахОтвет", "ВопросДляСтрок");
		
	ИначеЕсли ТипТабличногоВопроса =  ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВСтроках") Тогда
		
		УстановитьСвязьПараметраВыбораОтветаИВопроса("ОтветыСтрокиОтветыВСтрокахОтвет", "ВопросДляСтрок");
		
	ИначеЕсли ТипТабличногоВопроса =  ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.ПредопределенныеОтветыВКолонках") Тогда
		
		УстановитьСвязьПараметраВыбораОтветаИВопроса("ОтветыКолонкиОтветыВКолонкахОтвет", "ВопросДляКолонок");
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСвязьПараметраВыбораОтветаИВопроса(ИмяПоляОтвета, ИмяРеквизитаВопрос)

	НайденныеВопросы = Вопросы.НайтиСтроки(Новый Структура("ЭлементарныйВопрос", ЭтотОбъект[ИмяРеквизитаВопрос]));
	Если НайденныеВопросы.Количество() > 0 Тогда
		НайденныйВопрос = НайденныеВопросы[0];
		Если НайденныйВопрос.ТипОтвета = Перечисления.ТипыОтветовНаВопрос.ОдинВариантИз
			ИЛИ НайденныйВопрос.ТипОтвета = Перечисления.ТипыОтветовНаВопрос.НесколькоВариантовИз Тогда
			МассивПараметровВыбора = Новый Массив;
			СвязьПараметраВыбора = Новый СвязьПараметраВыбора("Отбор.Владелец", ИмяРеквизитаВопрос, РежимИзмененияСвязанногоЗначения.Очищать);
			МассивПараметровВыбора.Добавить(СвязьПараметраВыбора);
			СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
			Элементы[ИмяПоляОтвета].СвязиПараметровВыбора = СвязиПараметровВыбора;
		Иначе
			Элементы[ИмяПоляОтвета].СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
		КонецЕсли;
	Иначе
		Элементы[ИмяПоляОтвета].СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;

КонецПроцедуры


// Вызывается при изменении элементов форма, связанных с таблицей ответов.
// Параметры:
//   Элемент  - ТаблицаФормы - ЭлементКоторыйВызвал изменение.
//
&НаКлиенте
Процедура ПриИзмененииОтветов(Элемент)
	
	УправлениеДоступностью();
	УстановитьОтборы();
	Элемент.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЭлементПодбораОтветовПослеДобавления(Элемент,ДобавленнаяСтрока)
	
	УстановитьОтборы();
	Элемент.Обновить();
	УправлениеДоступностью();
	Элемент.ТекущаяСтрока = ДобавленнаяСтрока.ПолучитьИдентификатор();
	Элемент.ИзменитьСтроку();

КонецПроцедуры

&НаКлиенте
Функция ДобавлениеОтветаИнтерактивно(Элемент,Копирование,НомерОпорногоВопроса)

	Если Копирование Тогда
		
		НоваяСтрока = Ответы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Элемент.ТекущиеДанные);
		
	Иначе	
		
		Если Вопросы.Количество() >= НомерОпорногоВопроса+1 Тогда
			
			НоваяСтрока = Ответы.Добавить();
			НоваяСтрока.ЭлементарныйВопрос = Вопросы[НомерОпорногоВопроса].ЭлементарныйВопрос;
			
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаКлиенте
Процедура ЗакончитьРедактированиеИЗакрыть()
	
	Если ТипТабличногоВопроса = ПредопределенноеЗначение("Перечисление.ТипыТабличныхВопросов.Составной") Тогда
		Ответы.Очистить();
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	Оповестить("ОкончаниеРедактированияПараметровТабличногоВопроса",СформироватьСтруктуруПараметровДляПередачиВладельцу());
	Закрыть();
	
КонецПроцедуры

// Очищает ответы и заполняет их вариантами ответов.
//
// Параметры:
//  ЭлементарныйВопрос - ПланВидовХарактеристикСсылка.ВопросыДляАнкетирования.
//
&НаСервере
Процедура ОчиститьЗаполнитьВариантыОтветов(ЭлементарныйВопрос)
	
	Если Не ЗначениеЗаполнено(ЭлементарныйВопрос) Тогда
		Возврат;	
	КонецЕсли;
	
	НайденныеСтроки = Ответы.НайтиСтроки(Новый Структура("ЭлементарныйВопрос", ЭлементарныйВопрос));
	Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Ответы.Удалить(Ответы.Индекс(НайденнаяСтрока));
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВариантыОтветовАнкет.Ссылка КАК Ответ
	|ИЗ
	|	Справочник.ВариантыОтветовАнкет КАК ВариантыОтветовАнкет
	|ГДЕ
	|	ВариантыОтветовАнкет.Владелец = &ЭлементарныйВопрос
	|	И (НЕ ВариантыОтветовАнкет.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВариантыОтветовАнкет.РеквизитДопУпорядочивания";
	
	Запрос.УстановитьПараметр("ЭлементарныйВопрос",ЭлементарныйВопрос);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Ответы.Добавить();
			НоваяСтрока.ЭлементарныйВопрос = ЭлементарныйВопрос;
			НоваяСтрока.Ответ              = Выборка.Ответ;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыВопроса(Вопрос)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Вопрос,"Представление,Формулировка,ЭтоГруппа,ТипОтвета");
	
КонецФункции

#КонецОбласти
