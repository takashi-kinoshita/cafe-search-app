document.addEventListener("DOMContentLoaded", function() {
    console.log("script.js is loaded");

    const searchForm = document.getElementById("search_form");
    const nameElement = document.getElementById("name");
    
    if (searchForm && nameElement) {
        searchForm.addEventListener("submit", function(event) {
            event.preventDefault();
            const cafeName = nameElement.value;
            searchCafes(cafeName);
        });
    } else {
        console.error("search_form or name elements not found in the DOM");
    }
});

let map;
let service;
let centerLocation = {lat: 35.6895, lng: 139.6917};

function initMap() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            centerLocation = {lat: position.coords.latitude, lng: position.coords.longitude};
            createMap(centerLocation);
        }, function() {
            createMap(centerLocation);
        });
    } else {
        createMap(centerLocation);
    }
}

window.initMap = initMap;

function createMap(centerLocation) {
    map = new google.maps.Map(document.getElementById('map'), {zoom: 10, center: centerLocation});
    service = new google.maps.places.PlacesService(map);
}

function searchCafes(cafeName) {
    const request = {
        location: centerLocation,
        radius: '50000',
        query: cafeName + " カフェ"
    };
    service.textSearch(request, callback);
}

function callback(results, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
        for (let i = 0; i < results.length; i++) {
            const place = results[i];
            createMarker(place);
        }
    }
}

function createMarker(place) {
    const marker = new google.maps.Marker({
        map: map,
        position: place.geometry.location
    });

    const cafeId = saveCafeToDatabase(place);

    const infowindow = new google.maps.InfoWindow();
    google.maps.event.addListener(marker, 'click', function() {
        const contentDiv = document.createElement('div');
        contentDiv.innerHTML = `
            <div>
                <strong>${place.name}</strong><br>
                ${place.formatted_address}<br>
            </div>
        `;

        const favoriteButton = document.createElement('button');
        favoriteButton.textContent = 'お気に入りに追加';
        favoriteButton.addEventListener('click', function() {
            addToFavorites(cafeId, place.name, place.formatted_address);
        });

        contentDiv.appendChild(favoriteButton);

        infowindow.setContent(contentDiv);
        infowindow.open(map, this);
    });
}

function saveCafeToDatabase(place) {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/api/saveCafe', true); // '/api/saveCafe'は仮のエンドポイントです。実際のAPIエンドポイントに変更してください。
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            if (response && response.cafeId) {
                addToFavorites(response.cafeId);
            }
        }
    };
    xhr.send(JSON.stringify({
        name: place.name,
        address: place.formatted_address
        // 他の必要な情報をここに追加
    }));
}

function addToFavorites(cafeId, cafeName, cafeAddress) {
    const xhr = new XMLHttpRequest();

    // サーバーに送信するデータを準備
    const data = JSON.stringify({
        cafeId: cafeId,
        name: cafeName,
        address: cafeAddress
    });

    xhr.open('POST', '/api/favorites', true); // POSTリクエストを'/api/favorites'エンドポイントに送信
    xhr.setRequestHeader('Content-Type', 'application/json'); // JSON形式でデータを送信

    xhr.onload = function() {
        if (xhr.status === 200) {
            alert('お気に入りに追加されました。');
        } else {
            alert('お気に入りに追加できませんでした。');
        }
    };

    // リクエストを送信
    xhr.send(data);
}

document.addEventListener("DOMContentLoaded", function() {
    const searchNearbyButton = document.getElementById("search-nearby");

    if (searchNearbyButton) {
        searchNearbyButton.addEventListener("click", function(event) {
            event.preventDefault();
            searchCafesNearby();
        });
    } else {
        console.error("search-nearby element not found in the DOM");
    }
});

function searchCafesNearby() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const userLocation = {lat: position.coords.latitude, lng: position.coords.longitude};
            const request = {
                location: userLocation,
                radius: '5000',
                query: "カフェ"
            };
            service.textSearch(request, callback);
        });
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}
