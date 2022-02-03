# Зачетная работа по курсу "Языки Интернет-программирования"

> В рамках курса ["Языки Интернет-программирования"][7] студенты получают базовые знания о языках HTML, CSS, Javascript, JSON, XML, XPath, XSLT, изучают язык Ruby в качестве самостоятельно языка программирования и в контексте применения средств Ruby on Rails, которые используются для изучения принципов построения современных веб-приложений. 

## Требования

**Задание**: реализовать RoR-приложение, удовлетворяющее следующим условиям:
- Необходимо иметь контроллеры, обеспечивающие обработку запросов.
- Необходимо использовать модели для хранения данных в БД.
- Необходимо обеспечить аутентификацию пользователей.
- При реализации клиентской части необходимо применить код на языке Javascript и таблицы стилей CSS.
- Провести интернационализацию приложения и обеспечить вывод надписей на русском языке.

Приложение должно содержать полный набор тестов, позволяющих проверить все аспекты его функционирования.

## Выполнение работы

В рамках зачетной работы был разработан веб-сайт английского словаря, позволяющего пользователям учить слова и проверять свои знания.  
Работа словаря организована следующим образом. Зайдя на сайт, любой пользователь может воспользоваться поиском слова, рассмотреть его значения, прослушать правильное произношение. Войдя в систему, человек сможет добавить к себе в карточки для изучения слова с конкретными определениями на английском языке.

## Использованные сервисы и добавленные гемы

- [freeDictionaryAPI][1]
- [damerau-levenshtein][2]
- [http][3]
- [devise][4]
- [bcrypt][5]
- [faker][6]

*Список всех зависимостей можно найти в файлах проекта*

[1]: <https://dictionaryapi.dev/> "API-сервис английского толкового словаря"
[2]: <https://rubygems.org/gems/damerau-levenshtein/versions/1.1.0> "Гем для применения алгоритма Дамерау — Левенштейна"
[3]: <https://github.com/httprb/http> "Гем для реализации HTTP-запросов"
[4]: <https://github.com/heartcombo/devise> "Гем для авторизации пользователей"
[5]: <https://github.com/bcrypt-ruby/bcrypt-ruby> "Гем создания хешей паролей для тестирования приложения"
[6]: <https://github.com/faker-ruby/faker> "Гем генерации фальшивой информации для тестирования приложения"
[7]: <https://e-learning.bmstu.ru/iu6/course/view.php?id=119> "Курс \"ЯИП\" на сайте ведущей кафедры"