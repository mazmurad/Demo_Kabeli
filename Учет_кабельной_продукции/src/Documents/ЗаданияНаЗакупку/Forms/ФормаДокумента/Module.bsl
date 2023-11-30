
#Область ОбработчикиСобытийФормы
 &НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Скан(Команда)
	
	ОбработчикВыбораФайла = Новый ОписаниеОповещения("ПродолжитьВыборСканДокумента", ЭтотОбъект);
	РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, УникальныйИдентификатор,,Неопределено, ОбработчикВыбораФайла);	
		
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
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
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Аннулировать(Команда)
	
	ОбработчикВопроса = Новый ОписаниеОповещения("ПродолжитьВыполнениеПОслеОтветаНаВопросАннулировать", ЭтотОбъект);	
	ПоказатьВопрос(ОбработчикВопроса, "Аннулировать документ?", РежимДиалогаВопрос.ДаНет); 	
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТаблицыФормыКабельныеЛинии
&НаКлиенте
Процедура КабельныеЛинииПринятоПриИзменении(Элемент)      
	
	ТекущиеДанные = Элементы.КабельныеЛинии.ТекущиеДанные;		
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	Принято                   = ТекущиеДанные.Принято;
	ТекущиеДанные.Комментарий = ?(Принято, "", ТекущиеДанные.Комментарий);

	УстановитьДоступностьКомментарийВТЧКабельныеЛинии(ТекущиеДанные);
	
КонецПроцедуры 

&НаКлиенте
Процедура КабельныеЛинииПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	УстановитьДоступностьКомментарийВТЧКабельныеЛинии(Элемент.ТекущиеДанные);

КонецПроцедуры
#КонецОбласти

#Область ПрочиеПроцедурыИФункции 
&НаКлиенте
Процедура УстановитьДоступностьКомментарийВТЧКабельныеЛинии(ТекущиеДанные)   
	
	Элементы.КабельныеЛинииКомментарий.ТолькоПросмотр = ТекущиеДанные.Принято;
		
КонецПроцедуры	

&НаКлиенте
Процедура ПродолжитьВыполнениеПОслеОтветаНаВопросАннулировать(Результат, Параметры) Экспорт

    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
	КонецЕсли;
	
	АннулироватьДокумент();
	
КонецПроцедуры

 &НаСервере
Процедура АннулироватьДокумент()
	 
	Объект.СтатусДокумента = Перечисления.СтатусыЗаданийНаЗакупку.Аннулировано;	 	
	Записать();
	
КонецПроцедуры 

&НаКлиенте
Процедура ПродолжитьВыборСканДокумента(Результат, НомерВК) Экспорт  
		
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КабельныеЛинииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти