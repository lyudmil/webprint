# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def show_notice
        show :notice
    end

    def show_error
        show :error
    end

    private

    def show flash_type
        content_tag(:span, flash[flash_type], :class => flash_type) if flash[flash_type]
    end
end
