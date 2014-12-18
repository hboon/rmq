module RubyMotionQuery
  module Stylers

    TEXT_ALIGNMENTS = {
      left: NSTextAlignmentLeft,
      center: NSTextAlignmentCenter,
      right: NSTextAlignmentRight,
      justified: NSTextAlignmentJustified,
      natural: NSTextAlignmentNatural
    }

    KEYBOARD_TYPES = {
      default: UIKeyboardTypeDefault,
      ascii: UIKeyboardTypeASCIICapable,
      numbers_punctuation: UIKeyboardTypeNumbersAndPunctuation,
      url: UIKeyboardTypeURL,
      number_pad: UIKeyboardTypeNumberPad,
      phone_pad: UIKeyboardTypePhonePad,
      name_phone_pad: UIKeyboardTypeNamePhonePad,
      email_address: UIKeyboardTypeEmailAddress,
      email: UIKeyboardTypeEmailAddress, # Duplicate to help developers
      decimal_pad: UIKeyboardTypeDecimalPad,
      twitter: UIKeyboardTypeTwitter,
      web_search: UIKeyboardTypeWebSearch,
      alphabet: UIKeyboardTypeASCIICapable
    }

    RETURN_KEY_TYPES = {
      default: UIReturnKeyDefault,
      go: UIReturnKeyGo,
      google: UIReturnKeyGoogle,
      join: UIReturnKeyJoin,
      next: UIReturnKeyNext,
      route: UIReturnKeyRoute,
      search: UIReturnKeySearch,
      send: UIReturnKeySend,
      yahoo: UIReturnKeyYahoo,
      done: UIReturnKeyDone,
      emergency_call: UIReturnKeyEmergencyCall
    }

    SPELL_CHECKING_TYPES = {
      default: UITextSpellCheckingTypeDefault,
      no: UITextSpellCheckingTypeNo,
      yes: UITextSpellCheckingTypeYes
    }

    BORDER_STYLES = {
      none: UITextBorderStyleNone,
      line: UITextBorderStyleLine,
      bezel: UITextBorderStyleBezel,
      rounded_rect: UITextBorderStyleRoundedRect,
      rounded: UITextBorderStyleRoundedRect
    }

    # When you create a styler, always inherit UIViewStyler
    class UIViewStyler
      def initialize(view)
        @view = view
      end

      # If a view is reset, all state should be reset as well
      def view=(value)
        @view = value
      end
      def view
        @view
      end
      alias :get :view

      def view_has_been_styled?
        !@view.rmq_data.style_name.nil?
      end

      def frame=(value)
        RubyMotionQuery::Rect.update_view_frame(view, value)
      end
      def frame
        RubyMotionQuery::Rect.frame_for_view(@view)
      end

      # Sets the frame using the Window's coordinates
      def absolute_frame=(value)
        # TODO change to new rect system
        self.frame = value

        f = @view.frame
        window_point = @view.convertPoint(f.origin, fromView: nil)
        f.origin.x += window_point.x
        f.origin.y += window_point.y
        @view.frame = f
      end

      def prev_frame
        if (pv = prev_view) && !RubyMotionQuery::RMQ.is_blank?(pv)
          RubyMotionQuery::Rect.frame_for_view(pv)
        else
          CGRectZero
        end
      end

      def prev_view
        pv = @view.rmq.prev.get
        if RubyMotionQuery::RMQ.is_blank?(pv)
          nil
        else
          pv
        end
      end

      def bounds=(value)
        RubyMotionQuery::Rect.update_view_bounds(view, value)
      end
      def bounds
        RubyMotionQuery::Rect.bounds_for_view(@view)
      end

      def superview
        @view.superview || rmq(@view).root_view || rmq.window
      end
      alias :parent :superview

      def super_height
        if @view.superview
          @view.superview.frame.size.height
        else
          0
        end
      end

      def super_width
        if @view.superview
          @view.superview.frame.size.width
        else
          0
        end
      end

      def tag(tags)
        rmq.wrap(@view).tag(tags)
      end

      def center=(value)
        @view.center = value
      end
      def center
        @view.center
      end

      def center_x=(value)
        c = @view.center
        c.x = value
        @view.center = c
      end
      def center_x
        @view.center.x
      end

      def center_y=(value)
        c = @view.center
        c.y = value
        @view.setCenter c
      end
      def center_y
        @view.center.y
      end

      def background_color=(value)
        @view.setBackgroundColor value
      end
      def background_color
        @view.backgroundColor
      end

      def background_image=(value)
        @view.setBackgroundColor UIColor.colorWithPatternImage(value)
      end

      def z_position=(index)
        @view.layer.setZPosition index
      end
      def z_position
        @view.layer.zPosition
      end

      def opaque=(value)
        @view.layer.setOpaque value
      end
      def opaque
        @view.layer.isOpaque
      end

      def hidden=(value)
        @view.setHidden value
      end
      def hidden
        @view.isHidden
      end

      def enabled=(value)
        @view.setEnabled value
      end
      def enabled
        @view.isEnabled
      end

      def scale=(amount)
        if amount == 1.0
          @view.transform = CGAffineTransformIdentity
        else
          if amount.is_a?(NSArray)
            width = amount[0]
            height = amount[1]
          else
            height = amount
            width = amount
          end

          @view.transform = CGAffineTransformMakeScale(width, height)
        end
      end

      def rotation=(new_angle)
        radians = new_angle * Math::PI / 180
        @view.transform = CGAffineTransformMakeRotation(radians)
      end

      def content_mode=(value)
        @view.setContentMode value
      end
      def content_mode
        @view.contentMode
      end

      def clips_to_bounds=(value)
        @view.clipsToBounds = value
      end
      def clips_to_bounds
        @view.clipsToBounds
      end

      def tint_color=(value)
        @view.tintColor = value if @view.respond_to?('setTintColor:')
      end
      def tint_color ; @view.tintColor ; end

      def layer
        @view.layer
      end

      def opacity=(value)
        @view.layer.opacity = value
      end
      def opacity
        @view.layer.opacity
      end

      def border_width=(value)
        @view.layer.borderWidth = value
      end

      def border_width
        @view.layer.borderWidth
      end

      def border_color=(value)
        if is_color(value)
          @view.layer.setBorderColor(value.CGColor)
        else
          @view.layer.setBorderColor value
        end
      end

      def border_color
        @view.layer.borderColor
      end

      def border=(options)
        self.border_width = options.fetch(:width)
        self.border_color = options.fetch(:color)
      end

      def corner_radius=(value = 2)
        @view.clipsToBounds = true
        @view.layer.cornerRadius = value
      end

      def corner_radius
        @view.layer.cornerRadius
      end

      def masks_to_bounds=(value)
        @view.layer.masksToBounds = value
      end

      def masks_to_bounds
        @view.layer.masksToBounds
      end

      def accessibility_label=(value)
        @view.accessibilityLabel = value
      end

      def validation_errors=(values)
        # set custom validation messages on rules
        @view.rmq_data.validation_errors = values
      end

      def alpha ; view.alpha ; end
      def alpha=(v) ; view.alpha = v ; end

      private

      def is_color(value)
        [UICachedDeviceRGBColor, UIDeviceRGBColor].include?(value.class)
      end
    end
  end
end
