﻿////////////////////////////////////////////////////////////////////
//
// Объект-помощник для генерации файла шагов для Gherkin-спецификаций
//
//////////////////////////////////////////////////////////////////

#Использовать logos
#Использовать asserts
// #Использовать strings

Перем Лог;
Перем ЧитательГеркин;

Перем ВозможныеТипыШагов;
Перем ВозможныеКлючиПараметров;
Перем ПредставленияТиповПараметров;

////////////////////////////////////////////////////////////////////
//{ Программный интерфейс

Функция СоздатьФайлРеализацииШагов(ФайлФичи) Экспорт
	Лог.Отладка("Подготовка к генерации шагов спецификации "+ФайлФичи.ПолноеИмя);
	Ожидаем.Что(ФайлФичи, "Ожидали, что файл фичи будет передан как файл, а это не так").ИмеетТип("Файл");

	Лог.Отладка("Читаю фичу");

	РезультатыРазбора = ЧитательГеркин.ПрочитатьФайлСценария(ФайлФичи);

	ФайлШагов = СоздатьПустойФайлШагов(ФайлФичи);
	ФайлШагов = ЗаполнитьФайлШагов(ФайлФичи, РезультатыРазбора, ФайлШагов);

	Возврат ФайлШагов;
КонецФункции

//}

////////////////////////////////////////////////////////////////////
//{ Реализация

Функция СоздатьПустойФайлШагов(ФайлФичи)
	КаталогШагов = Новый Файл(ОбъединитьПути(ФайлФичи.Путь, "step_definitions"));
	Если Не КаталогШагов.Существует() Тогда
		Лог.Отладка("Каталог шагов не существует. Создаю новый. "+КаталогШагов.ПолноеИмя);
		СоздатьКаталог(КаталогШагов.ПолноеИмя);
	Иначе
		Лог.Отладка("Каталог шагов уже существует."+КаталогШагов.ПолноеИмя);
	КонецЕсли;

	ФайлШагов = Новый Файл(ОбъединитьПути(КаталогШагов.ПолноеИмя, ФайлФичи.ИмяБезРасширения+ ".os"));
	Если Не ФайлШагов.Существует() Тогда
		Лог.Отладка("Файл шагов не существует. Создаю новый. "+ФайлШагов.ПолноеИмя);
	Иначе
		Лог.Отладка("Файл шагов уже существует. Перезаполняю."+ФайлШагов.ПолноеИмя);
	КонецЕсли;

	Возврат ФайлШагов;
КонецФункции

Функция ЗаполнитьФайлШагов(ФайлФичи, РезультатыРазбора, ФайлШагов)
	Лог.Информация("Начинаю генерацию шагов для спецификации "+ФайлФичи.ПолноеИмя);

	ДеревоФич = РезультатыРазбора.ДеревоФич;
	Ожидаем.Что(ДеревоФич, "Ожидали, что дерево фич будет передано как дерево значений, а это не так").ИмеетТип("ДеревоЗначений");

	НаборАдресовШагов = Новый Структура;

	ОписаниеЗаписываемогоФайла = Новый Структура;
	ОписаниеЗаписываемогоФайла.Вставить("ФайлШагов", ФайлШагов);

	ЗаписьФайла = Новый ЗаписьТекста(ФайлШагов.ПолноеИмя, "utf-8");
	ОписаниеЗаписываемогоФайла.Вставить("ЗаписьФайла", ЗаписьФайла);
	Попытка
		ЗаписатьБазовоеТелоШага(ЗаписьФайла, ДеревоФич.Строки[0], НаборАдресовШагов);

		РекурсивноЗаписатьШагиВФайл(ОписаниеЗаписываемогоФайла, ДеревоФич.Строки[0], НаборАдресовШагов);

		ЗаписьФайла.Закрыть();
	Исключение
		ОсвободитьОбъект(ЗаписьФайла);
		ВызватьИсключение;
	КонецПопытки;
	Лог.Информация("Генерация завершена.");

	Возврат ФайлШагов;
КонецФункции

Процедура ЗаписатьБазовоеТелоШага(ЗаписьФайла, Узел, НаборАдресовШагов)
	ЗаписьФайла.ЗаписатьСтроку("Перем БДД;");
	ЗаписьФайла.ЗаписатьСтроку("");
	ЗаписьФайла.ЗаписатьСтроку("Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт");
	ЗаписьФайла.ЗаписатьСтроку(Символы.Таб + "БДД = КонтекстФреймворкаBDD;");
	ЗаписьФайла.ЗаписатьСтроку("");
	ЗаписьФайла.ЗаписатьСтроку(Символы.Таб + "ВсеТесты = Новый Массив;");
	ЗаписьФайла.ЗаписатьСтроку("");

	НаборУжеДобавленныхШагов = Новый Структура;
	РекурсивноЗаписатьОпределенияШаговДляПолученияСпискаТестов(ЗаписьФайла, Узел, НаборАдресовШагов, НаборУжеДобавленныхШагов);

	ЗаписьФайла.ЗаписатьСтроку("");
	ЗаписьФайла.ЗаписатьСтроку(Символы.Таб + "Возврат ВсеТесты;");
	ЗаписьФайла.ЗаписатьСтроку("КонецФункции");
	ЗаписьФайла.ЗаписатьСтроку("");
КонецПроцедуры

Процедура РекурсивноЗаписатьОпределенияШаговДляПолученияСпискаТестов(ЗаписьФайла, Узел, НаборАдресовШагов, НаборУжеДобавленныхШагов)
	Лог.Отладка("Обхожу узел "+Узел.ТипШага+": "+Узел.Лексема+" <"+Узел.Тело+">");

	Если Узел.ТипШага = ВозможныеТипыШагов.Шаг Тогда
		Если Не НаборАдресовШагов.Свойство(Узел.АдресШага) И Не НаборУжеДобавленныхШагов.Свойство(Узел.АдресШага) Тогда
			ЗаписьФайла.ЗаписатьСтроку(Символы.Таб + "ВсеТесты.Добавить("""+Узел.АдресШага+""");");
			Лог.Отладка("В НаборУжеДобавленныхШагов добавляю шаг "+Узел.АдресШага);
			НаборУжеДобавленныхШагов.Вставить(Узел.АдресШага);
		КонецЕсли;
	КонецЕсли;

	Для Каждого СтрокаДерева Из Узел.Строки Цикл
		РекурсивноЗаписатьОпределенияШаговДляПолученияСпискаТестов(ЗаписьФайла, СтрокаДерева, НаборАдресовШагов, НаборУжеДобавленныхШагов);
	КонецЦикла;

КонецПроцедуры

Процедура РекурсивноЗаписатьШагиВФайл(ОписаниеЗаписываемогоФайла, Узел, НаборАдресовШагов)
	Лог.Отладка("Обхожу узел "+Узел.ТипШага+": "+Узел.Лексема+" <"+Узел.Тело+">");

	Если Узел.ТипШага = ВозможныеТипыШагов.Шаг Тогда
		Если НаборАдресовШагов.Свойство(Узел.АдресШага) Тогда
			Лог.Отладка("Шаг уже определен. Пропускаю. Шаг <"+Узел.АдресШага+">");
		Иначе
			ЗаписатьШаг(ОписаниеЗаписываемогоФайла, Узел);
			НаборАдресовШагов.Вставить(Узел.АдресШага, ОписаниеЗаписываемогоФайла.ФайлШагов.ПолноеИмя);
		КонецЕсли;
	КонецЕсли;

	Для Каждого СтрокаДерева Из Узел.Строки Цикл
		РекурсивноЗаписатьШагиВФайл(ОписаниеЗаписываемогоФайла, СтрокаДерева, НаборАдресовШагов);
	КонецЦикла;

КонецПроцедуры

Процедура ЗаписатьШаг(ОписаниеЗаписываемогоФайла, Узел)
	Лог.Отладка("Записываю шаг <"+Узел.АдресШага+">");

	ЗаписьФайла = ОписаниеЗаписываемогоФайла.ЗаписьФайла;

	СтрокаПараметров = ПолучитьСтрокуПараметров(Узел.Параметры);

	СтрокаДляЗаписи = СтрШаблон("//%1", Узел.Тело);
	Лог.Отладка("СтрокаДляЗаписи <"+СтрокаДляЗаписи+">");
	ЗаписьФайла.ЗаписатьСтроку(СтрокаДляЗаписи);
	СтрокаДляЗаписи = СтрШаблон("//##%1", Узел.АдресШага);
	Лог.Отладка("СтрокаДляЗаписи <"+СтрокаДляЗаписи+">");
	ЗаписьФайла.ЗаписатьСтроку(СтрокаДляЗаписи);

	ШаблонЗаписи = "%1 %2(%3) %4";
	СтрокаДляЗаписи = СтрШаблон(ШаблонЗаписи, "Процедура",  Узел.АдресШага, СтрокаПараметров, "Экспорт");
	Лог.Отладка("СтрокаДляЗаписи <"+СтрокаДляЗаписи+">");
	ЗаписьФайла.ЗаписатьСтроку(СтрокаДляЗаписи);

	ШаблонЗаписи = "%1 ВызватьИсключение ""%2"";";
	СтрокаДляЗаписи = СтрШаблон(ШаблонЗаписи, Символы.Таб, ЧитательГеркин.ТекстИсключенияДляЕщеНеРеализованногоШага());
	Лог.Отладка("СтрокаДляЗаписи <"+СтрокаДляЗаписи+">");
	ЗаписьФайла.ЗаписатьСтроку(СтрокаДляЗаписи);

	СтрокаДляЗаписи = "КонецПроцедуры";
	Лог.Отладка("СтрокаДляЗаписи <"+СтрокаДляЗаписи+">"+Символы.ПС);
	ЗаписьФайла.ЗаписатьСтроку(СтрокаДляЗаписи);
	ЗаписьФайла.ЗаписатьСтроку("");

КонецПроцедуры

Функция ПолучитьСтрокуПараметров(Знач Параметры)
	СтрокаПараметров = "";
	Если ЗначениеЗаполнено(Параметры) Тогда
		Номер = 1;
		Для Каждого ОписаниеПараметра Из Параметры Цикл
			Лог.Отладка("ОписаниеПараметра.Тип " + ОписаниеПараметра.Тип);
			ПредставлениеПараметра = ПолучитьПредставлениеПараметра(ОписаниеПараметра, Номер);
			СтрокаПараметров = СтрокаПараметров + ПредставлениеПараметра + ",";
			Номер = Номер + 1;
		КонецЦикла;
		СтрокаПараметров = Лев(СтрокаПараметров, СтрДлина(СтрокаПараметров)-1);
 	КонецЕсли;
	Возврат СтрокаПараметров;
КонецФункции // ПолучитьСтрокуПараметров()

Функция ПолучитьПредставлениеПараметра(ОписаниеПараметра, Номер)
	ПредставлениеПараметра = ПредставленияТиповПараметров[ОписаниеПараметра.Тип] + Номер;
	Возврат ПредставлениеПараметра;
КонецФункции // ПолучитьПредставлениеПараметра(ОписаниеПараметра, Номер)

Функция ИмяЛога() Экспорт
	Возврат "oscript.app.bdd-generate";
КонецФункции

//}

Функция Инициализация()
	Лог = Логирование.ПолучитьЛог(ИмяЛога());

	ЧитательГеркин = ЗагрузитьСценарий(ОбъединитьПути(ТекущийСценарий().Каталог, "gherkin-read.os"));

	ВозможныеТипыШагов = ЧитательГеркин.ВозможныеТипыШагов();
	ВозможныеКлючиПараметров = ЧитательГеркин.ВозможныеКлючиПараметров();
	ПредставленияТиповПараметров = ВозможныеПредставленияТиповПараметров();
КонецФункции

Функция ВозможныеПредставленияТиповПараметров()
	Рез = Новый Соответствие;
	Рез.Вставить(ВозможныеКлючиПараметров.Строка, "ПарамСтрока");
	Рез.Вставить(ВозможныеКлючиПараметров.Число, "ПарамЧисло");
	Рез.Вставить(ВозможныеКлючиПараметров.Дата, "ПарамДата");
	Возврат Рез;
КонецФункции // ВозможныеПредставленияТиповПараметров()
// }

///////////////////////////////////////////////////////////////////
// Точка входа

Инициализация();
