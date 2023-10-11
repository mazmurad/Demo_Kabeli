///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СведенияОПользователяхИВнешнихПользователях");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Выводит подробные сведения о всех пользователях,
		|включая настройки для входа (если указаны).'");
	НастройкиВарианта.ФункциональныеОпции.Добавить("ИспользоватьВнешнихПользователей");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СведенияОПользователях");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Выводит подробные сведения о пользователях,
		|включая настройки для входа (если указаны).'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СведенияОВнешнихПользователях");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Выводит подробные сведения о внешних пользователях,
		|включая настройки для входа (если указаны).'");
	НастройкиВарианта.ФункциональныеОпции.Добавить("ИспользоватьВнешнихПользователей");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("КлючВарианта") Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("КлючВарианта", "СведенияОПользователяхИВнешнихПользователях");
		ВыбраннаяФорма = "Отчет.СведенияОПользователях.Форма";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
