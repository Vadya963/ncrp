# База Данных
### Аккаунты (tbl_accounts)
id
_entity
login
password
email
ip
serial (или аналог, позволяющий идентифицировать устройство)
locale
layout
created
logined
accesslevel
warns
blocks

### Персонажи (tbl_characters)
id
_entity
accountid
nickname
x
y
z
xp
money (только наличка, депозит будет отдельно как счёт в банке, банков может быть несколько разных, следовательно и счета разные).
state (последнее состояние игрока, которое может ограничить его в действиях: например, в наручниках, парализован шокером, или паралич после инсульта)
eyes
skin (цвет кожи)( + надо узнать, что есть из вариантов одежды в гта5, вероятно тут нужно будет хранить json c перечнем ПРИМЕНЁННЫХ на персонажа элементов одежды и аксессуаров, или же выносить в отдельную таблицу где указывать предмет и на ком применён)
health
hunger
thirst



### Для паспорта
фото
firstname
lastname
национальность (американец, мексиканец, француз и тд)
место рождения
sex
birthday
birthmonth
birthyear


### Автомобили (tbl_vehicles)
id
_entity
id документа, указывающего кто владеет тачкой (из таблицы предметов)
model
plate
dirtlevel (если поддерживается. Делать условный не надо - народ забьёт и не будет обращать никакого внимания)
x
y
z
rx
ry
rz
цвет (надо посмотреть в чём хранится)

p.s. что касается тюнинга - скорее всего это всё тоже предметы игрового мира, которые нацеплены на автомобиль (как линзы на персонаже, так и спойлер на авто)


### Предметы В КОДЕ

name - системной имя, например burger, hotdog, pencil, book
title Бургер или автомобильный глушитель
type:
    0 - пищевой продукт (бургер, кола, борщ, компот) - что пополняет сытость
    1 - одежда (очки, футболка, носки, линзы) - то, что можно вешать на игрока и это будет видно всем
    2 - вещь (паспорт, ножницы, кружка, бита, книга) - такой предмет, который можно применять по назначению сразу. Предмет автономен и не требует скрепления с чем-то ещё.
    3 - автомобильная деталь (спойлер, крыло, дверь, стекло для двери, лобовое стекло, фара, колесо, двигатель) - составная часть автомобиля, которая отдельно от других частей совершенно бесполезна
вес
габариты (скорее всего уазывается тип одним числом, подразумевающим возможность держать в руках, положить в инвентарь (взять с собой), в рюкзак, в сумку, в багажник легковой авто, в багажник грузовой авто, в вертолёт, в самолёт. Чем выше цифра, тем больше она в себя включает. Например если шкаф можно положить в грузовое авто, то в грузовой самолёт он точно влезет. Но надо правильно расставить категории транспорта).


### Предметы В БД
id
_entity
itemid
property - json с указанием всех возможных свойств предмета
state - его состояние (в какм-то инвентаре, на земле, другое)
slot - место где он находиться (клетка в том или другом инвентаре )
parent - родительский айтем (контейнер), или персонаж, или другой инвентарь (очень зависит от состояния)
amount - возможно это стоит перенести в property
x
y
z




### Здания
id
_entity
id документа, указывающего кто владеет зданием (из таблицы предметов)

salex -координата точки }
saley -координата точки  } - координаты метки где можно купить бизнес, вероятно в этой точки надо будет спавнить объект - рекламный щит о продаже.
salez -координата точки }

doorx -координата двери }
doory -координата двери  } - координаты двери бизнеса после покупки.
doorz -координата двери }

territory - {x1, y1, z1, x2, y2, z2 ... x10, y10, z10} - координаты территории для построения полигона
name - имя или адрес.
price
вместимость (площадь)
inventory {json} - склад, который виден только владельцу.
logoimg - путь до логотипа или просто картинки здания



### Фракции/организации/бизнесы
Берём концепт из мафии
+
logoimg - путь до логотипа или просто картинки фракции/организации/бизнеса
description - текст описания, типа приветственное слово, может понадобится у Гуи
public_inventory {json} - ассортимент магазина или список услуг; то, что можно купить.
режим работы {json: days: {monday, thursday, friday}; hours: {800, 1930}} - это надо вводить обязательно (пример хороший в ЕТС2: автослаон закрыт. Работает с ПН по СБ с 8:00 до 19:00)
    800 - это 8:00, 1930 - это 19:30.
password - Я пока не знаю как это точно сделать, но допустим может быть магазин, доступный не всем, как в мафии Оружейный магазин Гарри. По мне универсальная система - это пароль, то есть поле password. Если пароль пустой, то содерижмое public_inventory доступно всем для показа и покупки. Иначе надо ввести пароль и тогда появится содержимое.



### Баны, муты
перенести из мафии, сделать графический интерфейс для добавления/удаления/редактирования




# Описание
(черновик)

1. Игроки
2. Автомобили
3. Фракции
4. Бизнесы (наследуют фракции)



## Игроки

Массив игроков:
Player players[]

Игрок:
Player {
    string firstname;
    string lastname;

    string money;
    string birthyear;
}


### Извлечение

players[N]
players[15]
players.get(15)

