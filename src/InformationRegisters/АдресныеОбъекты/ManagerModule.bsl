///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Обновляет данные субъектов РФ в адресных объектах.
// Записи сопоставляются по полю КодСубъектаРФ.
//
Процедура ОбновитьСоставСубъектовРФПоКлассификатору(НачальноеЗаполнениеИОбновлениеДанных = Ложь) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Классификатор = КлассификаторСубъектовРФ();
	
	// Выбираем те, которые есть в макете, но отсутствующие в регистре.
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Параметр.КодСубъектаРФ КАК КодСубъектаРФ
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Параметр
		|ИНДЕКСИРОВАТЬ ПО
		|	КодСубъектаРФ
		|;
		|
		|ВЫБРАТЬ
		|	Классификатор.КодСубъектаРФ КАК КодСубъектаРФ
		|ИЗ
		|	Классификатор КАК Классификатор
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.АдресныеОбъекты КАК АдресныеОбъекты
		|ПО
		|	АдресныеОбъекты.Уровень                    = 1
		|	И АдресныеОбъекты.КодСубъектаРФ              = Классификатор.КодСубъектаРФ
		|ГДЕ
		|	АдресныеОбъекты.Идентификатор ЕСТЬ NULL
		|");
	Запрос.УстановитьПараметр("Классификатор", Классификатор);
	НовыеСубъектыРФ = Запрос.Выполнить().Выгрузить();
	
	// Перезаписываем только отсутствующих.
	Набор = СоздатьНаборЗаписей();
	Отбор = Набор.Отбор.КодСубъектаРФ;
	
	Для Каждого СубъектРФ Из НовыеСубъектыРФ Цикл
		Отбор.Установить(СубъектРФ.КодСубъектаРФ);
		Набор.Очистить();
		
		ИсходныеДанные = Классификатор.Найти(СубъектРФ.КодСубъектаРФ, "КодСубъектаРФ");
		
		НовыйСубъектРФ = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйСубъектРФ, ИсходныеДанные);
		НовыйСубъектРФ.Уровень = 1;
		
		Если НачальноеЗаполнениеИОбновлениеДанных Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		Иначе
			Набор.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает информацию из классификатора субъектов РФ.
//
// Возвращаемое значение:
//     ТаблицаЗначений - поставляемые данные. Колонки:
//       * КодСубъектаРФ  - Число  - код классификатора субъекта, например 77 для Москвы.
//       * Наименование   - Строка - наименование субъекта по классификатору. Например "Московская".
//       * Сокращение     - Строка - наименование субъекта по классификатору. Например "Обл".
//       * ПочтовыйИндекс - Число  - индекс региона. Если 0 - то неопределено.
//       * Идентификатор  - УникальныйИдентификатор - идентификатор адресного объекта.
//
Функция КлассификаторСубъектовРФ() Экспорт
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(ПолучитьМакет("КлассификаторСубъектовРФ").ПолучитьТекст());
	Результат = СериализаторXDTO.ПрочитатьXML(Чтение);
	
	Возврат Результат;
	
КонецФункции

// Возвращает информацию о адресных сокращениях.
//
// Возвращаемое значение:
//   ТаблицаЗначений:
//    * Уровень       - Число  - уровень сокращения.
//    * Наименование  - Строка - полное наименование адресного объекта.
//    * Сокращение    - Строка - сокращенное наименование адресного объекта.
//    * СокращениеПриказаМинфинаРФ171н - Строка - сокращенное наименование
//      адресного объекта согласно приказу МинфинаРФ N 171н.
//   .
//
Функция АдресныеСокращения() Экспорт
	
	Макет = ПолучитьМакет("АдресныеСокращения");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	Результат = СериализаторXDTO.ПрочитатьXML(Чтение);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли