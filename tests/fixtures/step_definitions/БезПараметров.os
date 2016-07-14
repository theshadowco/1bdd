﻿Перем БДД;
Перем Журнал;
Перем КлючЖурнала;

Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯНичегоНеДелаю");
	ВсеШаги.Добавить("НичегоНеПроисходит");

	Возврат ВсеШаги;
КонецФункции

Процедура ЯНичегоНеДелаю() Экспорт
	ДобавитьВЖурнал("ЯНичегоНеДелаю");
КонецПроцедуры

Процедура НичегоНеПроисходит() Экспорт
	ДобавитьВЖурнал("НичегоНеПроисходит");

   Ожидаем.Что(Журнал[КлючЖурнала], "Ожидали, что журнал выполнения будет правильным, а это не так").Равно("ЯНичегоНеДелаю;НичегоНеПроисходит;");
КонецПроцедуры

Процедура ДобавитьВЖурнал(Строка, Параметр = "", Параметр2 = "") Экспорт
	Журнал.Вставить(КлючЖурнала, Журнал[КлючЖурнала]+Строка+";");

	Представление = СтрШаблон("                нахожусь внутри шага %1 %2, %3", Строка,
		ПредставлениеПараметра(Параметр), ПредставлениеПараметра(Параметр2));
	//Сообщить(Представление);
КонецПроцедуры

Функция ПредставлениеПараметра(Параметр)
	Возврат ?(ПустаяСтрока(Параметр), "", "<"+Параметр+">");
КонецФункции

КлючЖурнала = (Новый Файл(ТекущийСценарий().Источник)).ИмяБезРасширения;
Журнал = Новый Соответствие;
Журнал.Вставить(КлючЖурнала, "");
