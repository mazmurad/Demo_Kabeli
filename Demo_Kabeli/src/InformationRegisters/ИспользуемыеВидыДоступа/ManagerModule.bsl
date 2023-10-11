///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет данные регистра при изменении использования видов доступа.
//
// Параметры:
//  ЕстьИзменения - Булево - (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
//  БезОбновленияЗависимыхДанных - Булево - если Истина, тогда
//                  не вызвать процедуру ПриИзмененииИспользованияВидовДоступа и
//                  не планировать обновление параметров ограничения доступа.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено, БезОбновленияЗависимыхДанных = Ложь) Экспорт
	
	РегистрыСведений.ПараметрыРаботыВерсийРасширений.ЗаблокироватьДляИзмененияВФайловойИБ();
	СвойстваВидовДоступа = УправлениеДоступомСлужебный.СвойстваВидовДоступа();
	
	ИспользуемыеВидыДоступа = СоздатьНаборЗаписей().Выгрузить();
	
	Для Каждого СвойстваВидаДоступа Из СвойстваВидовДоступа.Массив Цикл
		
		Если СвойстваВидаДоступа.Имя = "ВнешниеПользователи"
		 Или СвойстваВидаДоступа.Имя = "Пользователи" Тогда
			// Эти виды доступа не могут быть отключены по функциональным опциям.
			Используется = Истина;
		Иначе
			Используется = Истина;
			ИнтеграцияПодсистемБСП.ПриЗаполненииИспользованияВидаДоступа(СвойстваВидаДоступа.Имя, Используется);
			УправлениеДоступомПереопределяемый.ПриЗаполненииИспользованияВидаДоступа(СвойстваВидаДоступа.Имя, Используется);
		КонецЕсли;
		
		Если Используется Тогда
			ИспользуемыеВидыДоступа.Добавить().ТипЗначенийДоступа = СвойстваВидаДоступа.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	НовыеДанные.ТипЗначенийДоступа
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	&ИспользуемыеВидыДоступа КАК НовыеДанные";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.ТипЗначенийДоступа,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("ТипЗначенийДоступа"));
	
	Запрос = Новый Запрос;
	ИспользуемыеВидыДоступа.Свернуть("ТипЗначенийДоступа");
	Запрос.УстановитьПараметр("ИспользуемыеВидыДоступа", ИспользуемыеВидыДоступа);
	
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ИспользуемыеВидыДоступа", ТекстЗапросовВременныхТаблиц);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("РегистрСведений.ИспользуемыеВидыДоступа");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Данные = Новый Структура;
		Данные.Вставить("МенеджерРегистра",      РегистрыСведений.ИспользуемыеВидыДоступа);
		Данные.Вставить("ИзмененияСоставаСтрок", Запрос.Выполнить().Выгрузить());
		
		ЕстьТекущиеИзменения = Ложь;
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(Данные, ЕстьТекущиеИзменения);
		
		Если ЕстьТекущиеИзменения Тогда
			ЕстьИзменения = Истина;
			Если Не БезОбновленияЗависимыхДанных Тогда
				ПриИзмененииИспользованияВидовДоступа(Истина);
			КонецЕсли;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Параметры:
//  ЭлементДанных - РегистрСведенийНаборЗаписей.ИспользуемыеВидыДоступа
//
Процедура ЗарегистрироватьИзменениеПриЗагрузке(ЭлементДанных) Экспорт
	
	СтарыеЗначения = СоздатьНаборЗаписей();
	Если ЭлементДанных.Отбор.ТипЗначенийДоступа.Использование Тогда
		СтарыеЗначения.Отбор.ТипЗначенийДоступа.Установить(ЭлементДанных.Отбор.ТипЗначенийДоступа.Значение);
	КонецЕсли;
	
	СтарыеЗначения.Прочитать();
	
	Таблица = СтарыеЗначения.Выгрузить();
	Таблица.Колонки.Добавить("ВидИзмененияСтроки", Новый ОписаниеТипов("Число"));
	Таблица.ЗаполнитьЗначения(-1, "ВидИзмененияСтроки");
	
	Для Каждого Запись Из ЭлементДанных Цикл
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.ВидИзмененияСтроки = 1;
		НоваяСтрока.ТипЗначенийДоступа = Запись.ТипЗначенийДоступа;
	КонецЦикла;
	Таблица.Свернуть("ТипЗначенийДоступа", "ВидИзмененияСтроки");
	
	Изменения = Новый Массив;
	Для Каждого Строка Из Таблица Цикл
		Если Строка.ВидИзмененияСтроки = 0 Тогда
			Продолжить;
		КонецЕсли;
		Изменения.Добавить(Строка.ТипЗначенийДоступа);
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(Изменения) Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ГруппыДоступа.ЗарегистрироватьСсылки("ИспользуемыеВидыДоступа", Изменения);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ОбработатьИзменениеЗарегистрированноеПриЗагрузке() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Изменение настроек прав в АРМ заблокированы и не загружаются в область данных.
		Возврат;
	КонецЕсли;
	
	Изменения = Справочники.ГруппыДоступа.ЗарегистрированныеСсылки("ИспользуемыеВидыДоступа");
	Если Изменения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииИспользованияВидовДоступа(Истина);
	
	Справочники.ГруппыДоступа.ЗарегистрироватьСсылки("ИспользуемыеВидыДоступа", Null);
	
КонецПроцедуры

// Для процедур ОбновитьДанныеРегистра, ОбработатьИзменениеЗарегистрированноеПриЗагрузке.
Процедура ПриИзмененииИспользованияВидовДоступа(ПланироватьОбновлениеПараметровОграниченияДоступа = Ложь) Экспорт
	
	РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра();
	РегистрыСведений.ИспользуемыеВидыДоступаПоТаблицам.ОбновитьДанныеРегистра();
	
	Если ПланироватьОбновлениеПараметровОграниченияДоступа Тогда
		УправлениеДоступомСлужебный.ЗапланироватьОбновлениеПараметровОграниченияДоступа(
			"ПриИзмененииИспользованияВидовДоступа");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
