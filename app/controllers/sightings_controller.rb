class SightingsController < ApplicationController

    def index
        sightings = Sighting.all
        render json: sightings, include: [:bird, :location]
    end

    def show
        sighting = Sighting.find_by(id: params[:id])
        if sighting
            render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
            # different way of rendering similar outputs
            # render json: sighting, include: [:bird, :location], except: [:updated_at]
        else 
            render json: { message: "No sighting found with that id" }
        end
    end 
end
# line 11 produces nested objects in our rendered JSON for bird and location
# {
#     "id": 2,
#     "bird": {
#       "id": 2,
#       "name": "Grackle",
#       "species": "Quiscalus Quiscula",
#       "created_at": "2019-05-14T11:20:37.177Z",
#       "updated_at": "2019-05-14T11:20:37.177Z"
#     },
#     "location": {
#       "id": 2,
#       "latitude": 30.26715,
#       "longitude": -97.74306,
#       "created_at": "2019-05-14T11:20:37.196Z",
#       "updated_at": "2019-05-14T11:20:37.196Z"
#     }
# }

# if we rendered the json on line 13, and we wanted to also remove all instances of :created_at, :updated_at
# from the nested bird and location data, we'd have to add nesting into the options
# so the included bird and location data can have thier own options listed.
# def show
#     sighting = Sighting.find_by(id: params[:id])
#     render json: sighting.to_json(:include => {
#       :bird => {:only => [:name, :species]},
#       :location => {:only => [:latitude, :longitude]}
#     }, :except => [:updated_at])
# end

# this does produce a more specific set of data:
# {
#     "id": 2,
#     "bird_id": 2,
#     "location_id": 2,
#     "created_at": "2019-05-14T11:20:37.228Z",
#     "bird": {
#       "name": "Grackle",
#       "species": "Quiscalus Quiscula"
#     },
#     "location": {
#       "latitude": 30.26715,
#       "longitude": -97.74306
#     }
# }