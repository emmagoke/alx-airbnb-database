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
  location_id uuid [ref: > location.location_id]
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
  transaction_id varchar [null, unique] // External payment gateway transaction ID
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

Table country {
  country_id integer [primary key]
  name varchar [not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]
}

Table state {
  state_id integer [primary key]
  country_id integer [ref: > country.country_id]
  name varchar [not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]

  indexes {
    (country_id, name) [unique] //  Ensures state name is unique within its country
  }
}

// New Table for Zip Code Details (resolves the second transitive dependency)
Table zipCodeDetails {
  zip_code_id uuid [primary key]  // Using UUID for consistency if preferred, or zip_code itself if truly unique globally and simple
  zip_code varchar [not null, unique] // The actual zip/postal code
  city varchar [not null]
  state_id integer [ref: > state.state_id, not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]

  indexes {
    zip_code_id [pk]
    zip_code [unique]
    (city, state_id) // Common query pattern
  }
}

Table location {
  location_id uuid [primary key]
  street_address varchar [not null]     // e.g., "123 Maple Drive"
  address_line_2 varchar [null]       // e.g., "Apt 4B", "Suite 100"
  country_id integer [ref: > country.country_id]
  state_id integer [ref: > state.state_id]
  zip_code_id uuid [ref: > zipCodeDetails.zip_code_id, not null] // Links to ZipCodeDetails
  latitude decimal(9,6) [null]       // Optional: for mapping
  longitude decimal(9,6) [null]      // Optional: for mapping
  name varchar [not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]
  updated_at timestamp [note: "ON UPDATE CURRENT_TIMESTAMP"]

  indexes {
    location_id [pk]
    zip_code_id
  }
}

// Ref user_property: Property.host_id > User.user_id // many-to-one
// Ref user_posts: posts.user_id > users.id // many-to-one

// Ref: users.id < follows.following_user_id

// Ref: users.id < follows.followed_user_id


// Ref user_property: Property.host_id > User.user_id // many-to-one
// Ref user_posts: posts.user_id > users.id // many-to-one

// Ref: users.id < follows.following_user_id

// Ref: users.id < follows.followed_user_id
```
