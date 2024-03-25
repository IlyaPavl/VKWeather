# VKWeather

Приложение для просмотра погоды.
На главном экране отображается погода «на сегодня» крупным блоком, под погодой «на сегодня» есть несколько блоков с информацией о том, «как ощущается на улице», «облачность» в процентах и «скорость ветра» в м/с. В большом блоке ниже отображается погода на ближайшие 7 дней (реализовано с помощью UITableView).  
В правом нижнем углу есть кнопка поиска, при нажатии на которое открывается отдельный экран с поисковой строкой. Найдя нужный город, можно его выбрать и получить прогноз по нему. Если выбранный город не поддерживается API, приложение уведомит об этом.  
Для того, чтобы вновь отобразить погоду в вашей локации можно нажать на кнопку «геопозиции», находящей по центру toolbar. 

## Стэк
- Swift
- UIKit
- MapKit, CoreLocation
- Для организации поиска использовался MKLocalSearch
- MVVM
- Работа с сетью через URLSession

## Запрос геопозиции при первом старте 
<img width="456" alt="location2" src="https://github.com/IlyaPavl/VKWeather/assets/83919599/319f706b-11fe-43ad-9ea0-8cfba514aee0">

## Пример работы приложения
https://github.com/IlyaPavl/VKWeather/assets/83919599/6d6aae03-a5eb-4310-b82c-efed45e4fe8b



### Note: 
- Для того, чтобы протестировать работу по геопозиции через симулятор необходимо выбрать в Xcode в строке с выбором устройства симулятора следующее: VKWeather -> Edit Scheme -> Run -> Options -> Allow Location Simulation -> Default Location -> Выбрать из списка
<img width="938" alt="location1" src="https://github.com/IlyaPavl/VKWeather/assets/83919599/4bffc250-11b3-45a0-80b3-f9fcaffdef5b">

- В самом симуляторе в верхней строке необходимо выбрать Features -> Location -> например, Apple
<img width="456" alt="location2" src="https://github.com/IlyaPavl/VKWeather/assets/83919599/742f8e7a-e509-446a-ad8d-a0b8c9b444a3">

Если же запускать тестирование на физическом устройстве, то в строке с выбором устройства симулятора необходимо установить None: VKWeather -> Edit Scheme -> Run -> Options -> Allow Location Simulation -> Default Location -> None

