# energy-base

*Вертикальная модель данных (Entity Attribute Value)
Полезна, когда БД в процессе эксплуатации требует реализации многочисленных измениний в структуре. Например, раширение атрибутов понятий, определение новых связей между понятиями ИС. В рамках модели EAV добавление новых понятий не влечет за собой изменение состава и структуры таблиц базы данных, создавать новые понятия, также как и создавать и изменять состав их атрибутов, можно автоматизировано, и, главное, на любом этапе жизненного цикла ИС.
Недостатки - низкая производительность выполнения запросов по сравнению с реляционной моделью
           - сложность запросов
           - сложность соблюдения целостности данных

Для организации EAV на физическом уровне в реляционной базе дынных иметь три таблицы - таблицу, описывающую понятия, таблицу, описывающую атрибуты, таблицу, содержащую непосредственно значения атрибутов (при большом количестве данных ее луше разбить на таблицы по типу данных).
При этом таблица атрибутов содержит ссылку на идетификатор понятия из таблицы понятий, а таблица значений сожержит ссылки на идетификатор атрибута, позволяя, таким образом, определить к какому понятию относятся те или иные значения.

Этапы создания таблиц:
  1.
  2. Создание отдельной таблицы на каждый тип данных (строка, число, координаты, дата и т.д)

Заливка таблиц:
  1. Заливаем атрибуты и их описание (defined_attributes)
  2. Заливаем entity
  3. Заливаем power_plants - id plans должно соответствовать id type в Entity
  4. Заливаем 
