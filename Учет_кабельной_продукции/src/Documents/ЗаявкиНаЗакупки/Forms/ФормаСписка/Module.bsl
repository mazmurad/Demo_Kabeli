
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;                    
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	Выборка = Справочники.Подрядчик.Выбрать();	
	Пока Выборка.Следующий() Цикл
		СписокВыбораПодрядчика.Добавить(Выборка.Ссылка, Выборка.Ссылка);		
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти


#Область ОбработчикиКомандФормы   
&НаКлиенте
Процедура СоздатьДокументы(Команда)
	
	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("Форма", ЭтотОбъект);
	ПараметрыОбъекта.Вставить("СписокВыбораПодрядчика", СписокВыбораПодрядчика);
	ПараметрыОбъекта.Вставить("ИмяОбъекта", "ЗаявкиНаЗакупку");	
	ПараметрыОбъекта.Вставить("ОтборыКабельныхЛиний", "ПоРегиструЗаданияЗакупкиПринятыеКабельныеЛинии");	
	ПараметрыОбъекта.Вставить("Подрядчик", ОбщегоНазначенияПереопределяемый.ПодрядчикТекущегоПользователя());	    		
	ФормыДокументовОбработчикиКоманд.ВыборПодрядчикаИКабельныеЛинии(ПараметрыОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
#КонецОбласти


#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура УстановитьУсловноеОформление()

	//СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);

КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьЗаявкуНаЗакупки(Подрядчик, СписокКабельныхЛиний) Экспорт
	
	НоваяЗаявка           = Документы.ЗаявкиНаЗакупки.СоздатьДокумент();
	НоваяЗаявка.Дата      = ТекущаяДатаСеанса();
	НоваяЗаявка.Статус    = Перечисления.СтатусыЗаявкиНаЗакупку.ОжидаетЗаявку; 
	НоваяЗаявка.Подрядчик = Подрядчик;
	
	Для каждого ТекКабельнаяЛиния Из СписокКабельныхЛиний Цикл
		НовКабельнаяЛиния                = НоваяЗаявка.КабельныеЛинии.Добавить();
		НовКабельнаяЛиния.КабельнаяЛиния = ТекКабельнаяЛиния.Значение;
	КонецЦикла;
	
	НоваяЗаявка.Записать();
	
	Возврат НоваяЗаявка.Ссылка; 
	
КонецФункции
#КонецОбласти