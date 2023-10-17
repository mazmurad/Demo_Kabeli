   
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда		
		МодульУправленияДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправленияДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;	
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
			
		Если Параметры.Свойство("ЖурналУчетаКабельнойПродукции") Тогда
			Объект.ЖурналУчетаКабельнойПродукции = Параметры.ЖурналУчетаКабельнойПродукции;	
		КонецЕсли;		
		
		Если Параметры.Свойство("Подрядчик") Тогда
			Объект.Подрядчик = Параметры.Подрядчик;	
		КонецЕсли;
		
		Объект.Статус = Перечисления.СтатусыЖруналКабелей.Подготовлен;	
		
		Если Параметры.Свойство("ЭтоРабочееМесто") Тогда   
			
			Объект.Дата = ТекущаяДата();
			Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));	
		КонецЕсли;		
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	ОповеститьОВыборе(Объект.Ссылка);
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандыФормы
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)

	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры  

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)

	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
	
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()

	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)

	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтаФорма, Команда);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПодписатьЗаявку(Команда)

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;	
	КонецЕсли;
	
	Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЖруналКабелей.Подписан");	     
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);		
	Записать(ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура Отклонить(Команда)

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;	
	КонецЕсли;
	
	Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЖруналКабелей.Отклонен");	
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);		
	Записать(ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;	
	КонецЕсли;
	
	Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЖруналКабелей.Подготовлен");
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);			
	Записать(ПараметрыЗаписи);

КонецПроцедуры
#КонецОбласти

#Область СобытияПолейФормы
 &НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если ЭтоИзменениеЗаявки() Тогда
		Записать();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)

	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ИКЖПриИзменении(Элемент)
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);	
	Записать(ПараметрыЗаписи);	

КонецПроцедуры

&НаКлиенте
Процедура ДатаИКЖПриИзменении(Элемент)

	Записать();	

КонецПроцедуры

&НаКлиенте
Процедура ОригиналИКЖПриИзменении(Элемент)

	Записать();	
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапСтроительстваПриИзменении(Элемент)

	Если ЭтоИзменениеЗаявки() Тогда
		Записать();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПримечаниеПриИзменении(Элемент)

	Если ЭтоИзменениеЗаявки() Тогда
		Записать();	
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Функция ЭтоИзменениеЗаявки()
	
	Возврат ЗначениеЗаполнено(Объект.Ссылка);
	
КонецФункции
#КонецОбласти