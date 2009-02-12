module ActivitiesHelper

  # Given an activity, return a message for the feed for the activity's class.
  def feed_message(activity, recent = false)
    person = activity.person
    case activity_type(activity)
    when "BlogPost"
      post = activity.item
      blog = post.blog
      view_blog = blog_link(t('post.persons_blog', :person => h(person.name)), blog)
      if recent
        t 'post.new_blog_post_link', :blog_post => post_link(blog, post)
      else
        t 'post.person_posted_blog_post', :person => person_link_with_image(person), :blog_post => post_link(blog, post), :blog => view_blog
      end
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "BlogPost"
        post = activity.item.commentable
        blog = post.blog
        if recent
          t 'comment.to_persons_blog_post', :person => someones(blog.person, person), :blog_post => post_link(blog, post)
        else
          t 'comment.author_to_persons_blog_post', :author => person_link_with_image(person), :person => someones(blog.person, person), :person_blog_post => t('person.blog_post'), :blog_post => post_link(blog, post)
        end
      when "Person"
        if recent
          t 'comment.commented_on_activity', :activity => wall(activity)
        else
          t 'comment.person_commented_on_activity', 
            :person => person_link_with_image(activity.item.commenter), 
            :activity => wall(activity)
        end
      end
    when "Event"
      # TODO: make recent/long versions for this
      event = activity.item.commentable
      commenter = activity.item.commenter
      t 'comment.person_commented_on_organizer_event', 
        :person => person_link_with_image(commenter), 
        :organizer => someones(event.person, commenter), 
        :event => event_link(event.title, event)
    when "Connection"
      if activity.item.contact.admin?
        if recent
          t 'activity.just_joined'
        else
          t 'activity.person_joined', :person => person_link_with_image(activity.item.person)
        end
      else
        if recent
          t 'person.connected_with', :person => person_link_with_image(activity.item.contact)
        else
          t 'person.persons_have_connected', 
            :person1 => person_link_with_image(activity.item.person),
            :person2 => person_link_with_image(activity.item.contact)
        end
      end
    when "ForumPost"
      post = activity.item
      if recent
        t 'forum.new_forum_post', :topic => topic_link(post.topic)
      else
        t 'forum.person_posted', 
          :person => person_link_with_image(person),
          :topic => topic_link(post.topic)
      end
    when "Topic"
      if recent
        t 'topic.new_discussion', :topic => topic_link(activity.item)
      else
        t 'topic.person_posted', 
          :person => person_link_with_image(person),
          :topic => topic_link(activity.item)
      end
    when "Person"
      if recent
        t 'person.description_changed'
      else
        t 'person.persons_description_changed', :person => person_link_with_image(person)
      end
    when "Gallery"
      if recent
        t 'gallery.new_gallery_added', :gallery => gallery_link(activity.item)
      else
        t 'gallery.person_added_new_gallery', :person => person_link_with_image(person),
          :gallery => gallery_link(activity.item)
      end
    when "Photo"
      if recent
        t 'photo.new_photo_added', :photo => photo_link(activity.item), :gallery => to_gallery_link(activity.item.gallery)
      else
        t 'photo.person_added_new_photo', :person => person_link_with_image(person), :photo_str => t('photo.photo'),
          :photo => photo_link(activity.item), :gallery => to_gallery_link(activity.item.gallery)
      end
    when "Event"
      event = activity.item
      t 'event.person_created_event', :person => person_link_with_image(person),
        :event => event_link(event.title, event)
    when "EventAttendee"
      event = activity.item.event
      t 'event.person_attending_organizer_event', :person => person_link_with_image(person),
        :organizer => someones(event.person, person), :event => event_link(event.title, event)
    else
      raise t('activity.invalid_activity_type', :activity => activity_type(activity).inspect)
    end
  end
  
  def minifeed_message(activity)
    person = activity.person
    case activity_type(activity)
    when "BlogPost"
      post = activity.item
      blog = post.blog
      t 'post.person_new_blog_post', :person => person_link(person), :new_blog_post => post_link(t('post.new_blog_post'), blog, post)
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "BlogPost"
        post = activity.item.commentable
        blog = post.blog
        t 'comment.author_to_persons_blog_post', :author => person_link(person), :person => someones(blog.person, person), :person_blog_post => t('person.blog_post'), :blog_post => post_link(t('person.blog_post'), post.blog, post)
      when "Person"
        t 'comment.person_commented_on_activity', :person => person_link(activity.item.commenter), :activity => wall(activity)
      when "Event"
        event = activity.item.commentable
        t 'comment.person_commented_on_organizer_event', :person => person_link(activity.item.commenter), 
          :organizer => someones(event.person, activity.item.commenter), :event => event_link("event", event)
      end
    when "Connection"
      if activity.item.contact.admin?
        t 'activity.person_joined', :person => person_link(person)
      else
        t 'connection.persons_have_connected', :person1 => person_link(person), :person2 => person_link(activity.item.contact)
      end
    when "ForumPost"
      topic = activity.item.topic
      t 'forum.person_posted', :person => person_link(person), :topic => topic_link(topic)
    when "Topic"
      t 'topic.person_posted', :person => person_link(person), :topic => topic_link(activity.item)
    when "Person"
      t 'person.persons_description_changed', :person => person_link(person)
    when "Gallery"
      t 'gallery.person_added_new_gallery', :person => person_link(person), :gallery => gallery_link(activity.item)
    when "Photo"
      t 'photo.person_added_new_photo', :person => person_link(person), :photo => photo_link(activity.item), :gallery => to_gallery_link(activity.item.gallery)
    when "Event"
      t 'event.person_created_event', :person => person_link(person), :event => event_link(activity.item)
    when "EventAttendee"
      event = activity.item.event
      t 'event.person_attending_organizer_event', :person => person_link(person), :organizer => someones(event.person, person), :event => event_link(event)
    else
      raise t('activity.invalid_activity_type', :activity => activity_type(activity).inspect)
    end
  end
  
  # Given an activity, return the right icon.
  def feed_icon(activity)
    img = case activity_type(activity)
            when "BlogPost"
              "page_white.png"
            when "Comment"
              parent_type = activity.item.commentable.class.to_s
              case parent_type
              when "BlogPost"
                "comment.png"
              when "Event"
                "comment.png"
              when "Person"
                "sound.png"
              end
            when "Connection"
              if activity.item.contact.admin?
                "vcard.png"
              else
                "connect.png"
              end
            when "ForumPost"
              "asterisk_yellow.png"
            when "Topic"
              "note.png"
            when "Person"
                "user_edit.png"
            when "Gallery"
              "photos.png"
            when "Photo"
              "photo.png"
            when "Event"
              # TODO: replace with a png icon
              "time.gif"
            when "EventAttendee"
              # TODO: replace with a png icon
              "check.gif"
            else
              raise t('activity.invalid_activity_type', :activity => activity_type(activity).inspect)
            end
    image_tag("icons/#{img}", :class => "icon")
  end
  
  def someones(person, commenter, link = true)
    link ? t('person.persons', :person =>person_link_with_image(person)) : t('person.persons', :person => h(person.name))
  end
  
  def blog_link(text, blog)
    link_to(text, blog_path(blog))
  end
  
  def post_link(text, blog, post = nil)
    if post.nil?
      post = blog
      blog = text
      text = post.title
    end
    link_to(text, blog_post_path(blog, post))
  end
  
  def topic_link(text, topic = nil)
    if topic.nil?
      topic = text
      text = topic.name
    end
    link_to(text, forum_topic_path(topic.forum, topic))
  end
  
  def gallery_link(text, gallery = nil)
    if gallery.nil?
      gallery = text
      text = gallery.title
    end
    link_to(h(text), gallery_path(gallery))
  end
  
  def to_gallery_link(text = nil, gallery = nil)
    if text.nil?
      ''
    else
      t 'gallery.to_gallery', :gallery => gallery_link(text, gallery)
    end
  end
  
  def photo_link(text, photo= nil)
    if photo.nil?
      photo = text
      text = t('photo.photo')
    end
    link_to(h(text), photo_path(photo))
  end

  def event_link(text, event)
    link_to(text, event_path(event))
  end


  # Return a link to the wall.
  def wall(activity)
    commenter = activity.person
    person = activity.item.commentable
    link_to(t('person.person_wall', :person => someones(person, commenter, false)), 
      person_path(person, :anchor => "tWall"))
  end
  
  # Only show member photo for certain types of activity
  def posterPhoto(activity)
    shouldShow = case activity_type(activity)
    when "Photo"
      true
    when "Connection"
      true
    else
      false
    end
    if shouldShow
      image_link(activity.person, :image => :thumbnail)
    end
  end
  
  private
  
    # Return the type of activity.
    # We switch on the class.to_s because the class itself is quite long
    # (due to ActiveRecord).
    def activity_type(activity)
      activity.item.class.to_s      
    end
end
