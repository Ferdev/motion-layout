module Motion
  class Layout

    def initialize(&block)
      @verticals   = {}
      @horizontals = {}
      @metrics     = {}

      yield self
      strain
    end

    def metrics(metrics)
      @metrics = Hash[metrics.keys.map(&:to_s).zip(metrics.values)]
    end

    def subviews(subviews)
      @subviews = Hash[subviews.keys.map(&:to_s).zip(subviews.values)]
    end

    def view(view)
      @view = view
    end

    def horizontal(key, horizontal)
      key ||= @horizontals.size
      @horizontals[key] = horizontal
    end

    def vertical(key, vertical)
      key ||= @verticals.size
      @verticals[key] = vertical
    end

    def constraint(name)
      @constraints[name]
    end

    private

    def strain
      @subviews.values.each do |subview|
        subview.translatesAutoresizingMaskIntoConstraints = false
        @view.addSubview(subview) unless subview.superview
      end

      views = @subviews.merge("superview" => @view)

      @verticals.map do |key, vertical|
        constraints[key] = NSLayoutConstraint.constraintsWithVisualFormat("V:#{vertical}", options:NSLayoutFormatAlignAllCenterX, metrics:@metrics, views:views)
      end
      @horizontals.map do |key, horizontal|
        constraints[key] = NSLayoutConstraint.constraintsWithVisualFormat("H:#{horizontal}", options:NSLayoutFormatAlignAllCenterY, metrics:@metrics, views:views)
      end

      @view.addConstraints(constraints.values.flatten)
    end

    def constraints
      @constraints ||= {}
    end

  end
end
