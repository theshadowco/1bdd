﻿# encoding: utf-8
# language: ru

Функционал: Пустой функционал
	Как Разработчик
	Я Хочу чтобы файл фичи успешно прочитался

Сценарий: Использование параметров Число

	Когда я использую 5 и число2
	Тогда получаю 10 и сумму12

Сценарий: Использование параметров Дата с годом из 4-х цифр
	Когда я передаю параметр 11.02.2010
	Тогда я получаю параметр с типом "Дата"

Сценарий: Использование параметров Дата с годом из 2-х цифр
	Когда я передаю параметр 11.02.10
	Тогда я получаю параметр с типом "Дата"

Сценарий: Использование параметров Строка с кавычками внутри апострофов
		Когда я передаю параметр 'Начало "ВнутриКавычек" Конец'
		Тогда я получаю параметр с типом "Строка"

Сценарий: Использование знака минуса в тексте и в числах
		Когда я передаю параметр -5
		Тогда я использую строку-в-которой-есть-минус
