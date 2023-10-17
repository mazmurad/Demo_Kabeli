///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Формирует массив описаний возможных типов контактов
// 
// Возвращаемое значение:
//   ФиксированныйМассив из см. ВзаимодействияКлиентСервер.НовоеОписаниеКонтакта
//
Функция КонтактыВзаимодействий() Экспорт

	Результат = Новый Массив();
	
	Контакт = ВзаимодействияКлиентСервер.НовоеОписаниеКонтакта();
	Контакт.Тип = Тип("СправочникСсылка.Пользователи");
	Контакт.Имя = "Пользователи";
	Контакт.Представление = НСтр("ru = 'Пользователи'");
	Контакт.ВозможностьИнтерактивногоСоздания = Ложь;
	Контакт.ИскатьПоДомену = Ложь;
	Результат.Добавить(Контакт);
	
	ВзаимодействияКлиентСерверПереопределяемый.ПриОпределенииВозможныхКонтактов(Результат);
	Возврат Новый ФиксированныйМассив(Результат);

КонецФункции

Функция ПредметыВзаимодействий() Экспорт
	
	Предметы = Новый Массив;
	ВзаимодействияКлиентСерверПереопределяемый.ПриОпределенииВозможныхПредметов(Предметы);
	Возврат Новый ФиксированныйМассив(Предметы);
	
КонецФункции

#КонецОбласти
