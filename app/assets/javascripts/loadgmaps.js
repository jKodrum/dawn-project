function initGmaps(job_hash)
{
    handler = Gmaps.build('Google', {markers: {clusterer: {} } });
    var mapStyle = [];

    // Set options and onMapLoad function to build map
    mapOptions = { internal: {id: 'map'},
        provider: { styles: mapStyle }
    };
    mapFunc = function(){
        markers = handler.addMarkers(job_hash);
        _.each(job_hash, function(json, index){
            json.marker = markers[index];
        });
        // click job <tr> will focus to the corresponding marker
        bindJobToMarker(job_hash);

        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    }

    // Build the map
    handler.buildMap( mapOptions, mapFunc );
}

// click to <tr> section, 
// the map will focus to the marker of the correspoding id
function bindJobToMarker(json_array){
    _.each(json_array, function(json){
        $("#" + json.id).click(function(){ focus(json.marker); });
    });
};
function focus(marker){
    marker.setMap(handler.getMap()); //because clusterer removes map property from marker
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'click');
}
