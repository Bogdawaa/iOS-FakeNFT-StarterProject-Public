### Договорённости
* Вёрска кодом
* Архитектура MVP
* DI через swinject
* Трекер задач  https://github.com/users/Bogdawaa/projects/1

#### Ветки
* develop - общая ветка, куда будем мержить всей командой
* dmirain_catalog - основная моя ветка, которую потом буду мержить в develop
* dmirain_catalog_1 - ветка первого блока
* dmirain_catalog_2 - ветка второго блока
* dmirain_catalog_3 - ветка третьего блока

### Оценка сложности
* 1sp - минуты
* 2sp - час
* 3sp - час – два
* 5sp - два – пять часов

### План / Факт
#### 1. Сделать общую часть для все команды. **16sp / 16sp**
1. Договориться с командой об общей части. **1sp / 1sp**
2. Правильные константы цветов и шрифтов. **1sp / 1sp**
3. Поправлю настройки проекта. Отключу iPad и сделаю только портрет. **1sp / 1sp**
4. Удаляю MainStoryBoard и переделываю полностью на код. **1sp / 1sp**
5. LaunchScreen. **2sp / 1sp**
6. Иконка приложения. **1sp / 1sp**
7. Добавлю swinjet для DI. **1sp / 1sp**
8. Правила swiftlint. **1sp / 1sp**
9. Метрика. **2sp / 2sp**
10. Хост и секрет для сетевых запросов. **1sp / 1sp** 
11. Хелпер для переводов. **1sp / 1sp**
12. TabBar. **1sp / 1sp**
13. Передать команде сделанную общую часть, объяснив, что сделано и какие правила. **2sp / 3sp**  

#### 2. Сделать экран списка коллекций и отладить сетевое взаимодействие. **12sp / 13sp**
1. Вёрстка экарана списка коллекций **3sp / 3sp**
2. Разобраться с API **2sp / 1sp**
3. Классы Request **2sp / 5sp** Тут очень захотелось перемудрить
4. Сервис для получаения списка коллекций **2sp / 1sp**
5. Presenter, который соеденит сервис и вёрстку **1sp / 1sp**
6. Alert с выбором сортировки **2sp / 2sp**

#### 3. Экран коллекции nft. **15sp**
1. Вёрстка экрана коллекции **5sp**
2. Сервис для получаения NFT **1sp**
3. Presenter, который соеденит сервис и вёрстку **2sp**
4. Действие like **2sp**
5. Добавление в корзину **2sp**
6. Открытие сылки на автора **3sp**