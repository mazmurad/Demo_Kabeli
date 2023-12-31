	 
#Область СобытияФормы
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);	
	
	//РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);

КонецПроцедуры
#КонецОбласти	 


#Область ПодключаемыеКомандыБСП 
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)    
	
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);  
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры)

	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);	
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)   
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект); 
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()   
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);   
	
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура ВыбратьПроект(Команда)
	
	ПараметрыФормыВыбора = ПолучитьПараметрыФормыВыбора();		
	ДопПараметры         = Новый Структура("ИмяРеквизита", "Проект");
	
	ОткрытьФорму("Справочник.Проекты.ФормаВыбора", ПараметрыФормыВыбора, 
		ЭтаФорма,,,, Новый ОписаниеОповещения("ВыбратьЗавершение", ЭтотОбъект, ДопПараметры));
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКабельнаяЛиния(Команда)

	ПараметрыФормыВыбора = ПолучитьПараметрыФормыВыбора();	
	ДопПараметры         = Новый Структура("ИмяРеквизита", "КабельнаяЛиния");
	
	ОткрытьФорму("Справочник.КабельныеЛинии.ФормаВыбора", ПараметрыФормыВыбора, 
		ЭтаФорма,,,, Новый ОписаниеОповещения("ВыбратьЗавершение", ЭтотОбъект, ДопПараметры));		
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыФормыВыбора()

	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.Независимый);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Ложь);
	
	Возврат ПараметрыФормыВыбора;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда		
		Если ДополнительныеПараметры.Свойство("ИмяРеквизита") Тогда

			Объект[ДополнительныеПараметры.ИмяРеквизита] = Результат;
			
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура НомерПППриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура НомерВКПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура РазпешитьМонтажПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры




