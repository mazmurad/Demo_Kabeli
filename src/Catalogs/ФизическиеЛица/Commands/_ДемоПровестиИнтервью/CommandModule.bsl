///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не ИспользованиеВозможно() Тогда
		ТекстПредупреждения = НСтр("ru = 'Форма недоступна, не включена подсистема ""Анкетирование"".'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли; 
	
	АнкетированиеКлиент.НачатьИнтервью(ПараметрКоманды);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИспользованиеВозможно()
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьАнкетирование");
	
КонецФункции

#КонецОбласти
