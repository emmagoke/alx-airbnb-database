# Airbnb ERD

```text
// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs
enum users_role {
    guest
    host
    admin
}

enum booking_status {
    pending
    confirmed
    canceled
}

ENUM payment_method {
    credit_card
    paypal
    stripe
}

Table Users {
    user_id UUID [primary key]
    first_name varchar [not null]
    last_name varchar [not null]
    email varchar [unique, not null]
    password_hash varchar [not null]
    phone_number varchar [null]
    role users_role [not null]
    created_at timestamp [default: `CURRENT_TIMESTAMP`]

    indexes {
        user_id [pk]
    }
}

Table property {
    property_id uuid [primary key]
    host_id uuid [ref: > Users.user_id]
    name varchar [not null]
    description text [not null]
    location varchar [not null]
    pricepernight decimal [not null]
    created_at timestamp [default: `CURRENT_TIMESTAMP`]
    updated_at timestamp [note: "ON UPDATE CURRENT_TIMESTAMP"]

    indexes {
        property_id [pk]
    }
}

Table booking {
    booking_id uuid [primary key]
    property_id uuid [ref: > property.property_id]
    user_id uuid [ref: > Users.user_id]
    start_date date [not null]
    end_date date [not null]
    total_price decimal [not null]
    status booking_status [not null]
    created_at timestamp [default: `CURRENT_TIMESTAMP`]

    indexes {
        booking_id [pk]
    }
}

Table payment {
    payment_id uuid [primary key]
    booking_id uuid [ref: > booking.booking_id]
    amount decimal [not null]
    payment_date timestamp [default: `CURRENT_TIMESTAMP`]
    payment_method payment_method [not null]

    indexes {
        payment_id [pk]
    }
}

Table review {
    review_id uuid [primary key]
    property_id uuid [ref: > property.property_id]
    user_id uuid [ref: > Users.user_id]
    rating integer [not null, note: 'CHECK: rating >= 1 AND rating <= 5']
    comment text [not null]
    created_at timestamp [default: `CURRENT_TIMESTAMP`]

    indexes {
        review_id [pk]
    }
}

Table message {
    message_id uuid [primary key]
    sender_id uuid [ref: > Users.user_id]
    recipient_id uuid [ref: > Users.user_id]
    message_body text [not null]
    sent_at timestamp [default: `CURRENT_TIMESTAMP`]

    indexes {
        message_id [pk]
    }
}

// Ref user_property: Property.host_id > User.user_id // many-to-one
// Ref user_posts: posts.user_id > users.id // many-to-one

// Ref: users.id < follows.following_user_id

// Ref: users.id < follows.followed_user_id
```
