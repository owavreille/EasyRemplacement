class OfficeController < ApplicationController


    def index
        @doctors = Doctor.all
        @sites = Site.all
    end

end