---
title: Hive Javascript SDK

language_tabs: # must be one of https://git.io/vQNgJ
  - javascript

toc_footers:
  - <a href='https://www.hive.co/home'>Powered by Hive</a>

# includes:
#   - errors

search: true
---

# Introduction

The Hive Javascript SDK allows you to update your contact list in Hive from your own web properties - based on how users interact with your website or signup form.

# Getting Started

## 1 - Whitelist Your Domain

Your website's domain **must** be whitelisted in our system (i.e. approved) before you can run the Hive SDK on it. To whitelist a new domain, please email <a href="mailto:hello@hive.co">hello@hive.co</a>. Domains used for production and development sites can be whitelisted at the same time.

## 2 - Load the SDK

To load the Hive SDK on your site, add the following script to your HTML:

```html
<script type="text/javascript">
(function(h,i,v,e,s,d,k){h.HiveSDKObject=s;h[s]=h[s]||function(){(h[s].q=h[s].q||[]).push(arguments)},d=i.createElement(v),k=i.getElementsByTagName(v)[0];d.async=1;d.id=s;d.src=e+'?r='+parseInt(new Date()/60000);k.parentNode.insertBefore(d,k)})(window,document,'script','https://cdn-prod.hive.co/static/js/sdk-loader.js','HIVE_SDK')
</script>
```

## 3 - Initialize the SDK

You must initialize the Hive SDK on your website (by making a call to the <code>init</code> command) before calling any of the SDK's other commands (such as <code>emailSignup</code>). Commands made before an <code>init</code> command is made will be discarded, while any commands made afterwards (even during initialization) will be handled as soon as initialization is complete.

```javascript
HIVE_SDK("init", YOUR_BRAND_HIVE_ID, function (data) {
  // Initialization success callback
  // data.user contains info about the current user (if known)
  console.log(data.user?.email);
});
```

<aside class='notice'>
  Don't forget to replace <code>YOUR_BRAND_HIVE_ID</code> with your brand's id in Hive. For help finding your brand's id, please email <a href="mailto:hello@hive.co">hello@hive.co</a>.
</aside>

> The above command will call the callback function, containing the current user's information if the current user is already "authenticated" with Hive and your brand:

```js
{
  user: {
    id: 1,  // the user's id in Hive, useful for identifying users if saved within your application
    email: 'patrick@hive.co',
    firstName: 'Patrick',
    lastName: 'Hannigan',
  }
}
```

Make sure that you're initializing the SDK on a domain (or subdomain) that's been whitelisted for your brand id. If you are not sure that your domain has been whitelisted for your brand, please reach out to your account manager.

The callback argument in the <code>init</code> command will be executed once the SDK sucessfully initializes. If the current user is "authenticated" with Hive and your brand, the callback will be passed an object containing a <code>user</code> field including information about the currently "authenticated" user.

## 4 - Link the current user to your Brand

Making a call to any of the Hive SDK's "signup" commands will link the current user to this session's SDK events and add them to your Brand's Contact list in Hive. Hive may be able to identify the current user as a known Contact based on previous sessions, but this is not guaranteed.

<aside class='notice'>
SDK commands fired after <code>init</code> but before a Contact is linked (via a "signup" command or determined from a previous browsing session) are "buffered", and will not propagate into Hive until the correct Contact is identified. This includes automated commands such as page view tracking. As soon as a Contact is linked, all buffered commands will be "flushed" into Hive and that Contact's interaction history
</aside>

# Commands - Signup

<aside class='success'>
Commands in this group will not be buffered, since they link a Contact to them
</aside>

## Via Email Address

> To add a user via an email address (with an optional phone number), call the following code:

```javascript
HIVE_SDK(
  "emailSignup",
  {
    email: "patrick@hive.co",
    didOptIn: true, // optional

    phoneNumber: "+15198864500", // optional, ideally with a country code, i.e. +1 in this example
    didSmsOptIn: true, // optional

    firstName: "Patrick", // optional
    lastName: "Hannigan", // optional
    birthday: "01/25/1985", // optional, MM/DD/YYYY formatted

    location: "Kitchener, Ontario, Canada", // optional
    zipCode: "N2H 3X7", // optional
    country: "Canada", // optional
    city: "Kitchener", // optional
    state: "Ontario", // optional
    mailingAddress: "283 Duke St West, Unit 304", // optional
  },
  function (data) {
    // Success Callback
    // data.user contains info about the currently auth'ed user
    console.log(data);
  },
  function (data) {
    // Error Callback
    // data contains error information
    console.log(data);
  }
);
```

> The above code will in turn call the 'success' callback with the following JSON:

```js
{
  user: {
    id: 1,  // the user's id in Hive, useful for identifying users if saved within your application
    email: 'patrick@hive.co',
    firstName: 'Patrick',
    lastName: 'Hannigan',
  }
}
```

This command will take the provided user data, and use it to "authenticate" the current user and add them to your brand's contact list in Hive.

The <code>email</code> field is the only required field, although passing along as much data as possible is recommended. For instance, including <code>firstName</code> will help to generate a gender for your contacts in Hive. <code>location</code> should be a string with as much location granularity as possible (we'll take care of geocoding, etc. on our own).

If you're including a user's phone number, provide it in E.164 or RFC3966 format to ensure that it is properly saved. In cases where Hive cannot resolve a poorly formatted phone number, a default country code of `+1` (United States/Canada) will be assumed. Users with invalid phone numbers will not be saved into Hive.

To ensure you can legally send SMS messages to your contacts via Hive, you must also collect explicit opt-in consent from each user that complies with TCPA. If users have provided you with explicit consent to receive SMS messages, you should pass a value of <code>true</code> for the <code>didSmsOptIn</code> parameter. If this parameter is passed in as <code>false</code> (or if this parameter is not provided at all), then the user will still be imported into your Hive account but no SMS messages can be sent to them.

After the signup is successful, the 'success' callback will be called with information about the user. If something goes wrong, the 'error' callback function will be called with details regarding what went wrong.

<aside class='notice'>
  In some rare cases, users signing up with an email address already associated with a Hive admin account will be required to log in using their Hive password. We'll handle redirecting those users to their Hive login page, making sure they're "authenticated", and then redirect them back to your website.
</aside>

## Via Phone Number

> To add a user via a phone number only, call the following code:

```javascript
HIVE_SDK(
  "phoneNumberSignup",
  {
    phoneNumber: "+15198864500", // ideally with a country code, i.e. +1 in this example
    didSmsOptIn: true, // optional

    firstName: "Patrick", // optional
    lastName: "Hannigan", // optional
    birthday: "01/25/1985", // optional, MM/DD/YYYY formatted

    location: "Kitchener, Ontario, Canada", // optional
    zipCode: "N2H 3X7", // optional
    country: "Canada", // optional
    city: "Kitchener", // optional
    state: "Ontario", // optional
    mailingAddress: "283 Duke St West, Unit 304", // optional
  },
  function (data) {
    // Success Callback
    // data.user contains info about the currently auth'ed user
    console.log(data);
  },
  function (data) {
    // Error Callback
    // data contains error information
    console.log(data);
  }
);
```

> The above code will in turn call the 'success' callback with the following JSON:

```js
{
  user: {
    id: 1,  // the user's id in Hive, useful for identifying users if saved within your application
    firstName: 'Patrick',
    lastName: 'Hannigan',
  }
}
```

This command will take the provided user data, and use it to "authenticate" the current user and add them to your brand's contact list in Hive.

To ensure that phone numbers are properly saved, provide phone numbers in E.164 or RFC3966 format. In cases where Hive cannot resolve a poorly formatted phone number, a default country code of `+1` (United States/Canada) will be assumed. Users with invalid phone numbers will not be saved into Hive.

To ensure you can legally send SMS messages to your contacts via Hive, you must also collect explicit opt-in consent from each user that complies with TCPA. If users have provided you with explicit consent to receive SMS messages, you should pass a value of <code>true</code> for the <code>didSmsOptIn</code> parameter. If this parameter is passed in as <code>false</code> (or if this parameter is not provided), then the user will still be imported into your Hive account but no SMS messages can be sent to them.

The <code>phoneNumber</code> field is the only required field, although passing along as much data as possible is recommended. For instance, including <code>firstName</code> will help to generate a gender for your contacts in Hive. <code>location</code> should be a string with as much location granularity as possible (we'll take care of geocoding, etc. on our own).

After the signup is successful, the 'success' callback will be called with information about the user. If something goes wrong, the 'error' callback function will be called with details regarding what went wrong.

# Commands - Segments

<aside class='info'>
Commands in this group will be buffered until a Contact is linked to them
</aside>


## Add to Static Segment

> To add a user to a segment, call the following code:

```javascript
HIVE_SDK(
  "addToSegment",
  "VIP Contacts Segment", // any segment name you choose
  function () {}, // Success Callback
  function (data) {
    // Error Callback
    // data contains error information
    console.log(data);
  }
);
```

This command will add the currently "authenticated" user to a static segment in Hive that matches the name you provide. If a segment does not exist for the name you provided, one will be created.

# Commands - Orders/Purchases

<aside class='info'>
Commands in this group will be buffered until a Contact is linked to them
</aside>

## Save a Newly-Created Ticketing Order

> Call the following code to **create** an order:

```javascript
HIVE_SDK(
  "ticketingOrder",
  "create",
  {
    id: "unique_order_id_1234", // unique id for this order as saved into your own database
    status: "started", // one of: "started" (user has started order), "completed" (user has completed order)
    total_paid: 50.75,

    event: {
      id: "unique_event_id_1234", // unique id for this event as saved into your own database
      name: "St. Paddy's Day Outdoor Concert",
      description:
        "There will be live entertainment and lots of food! Parking is available across the street.", // (optional)
      start_time: "2019-03-17T10:00:00-04:00", // when does the event begin? in ISO 8601 format
      end_time: "2019-03-17T18:00:00-04:00", // when does the event end? in ISO 8601 format
      url: "http://example.com/events/1234-st-paddys-concert/", // a public url to buy tickets for this event
      image_url: "https://via.placeholder.com/500x100", // (optional) a banner image or other public image for this event

      artist_names: "Pat Flannigan, Andrew Sayer", // (optional) comma separated values
      genre_names: "Hip Hop, Electronic", // (optional) comma separated values
      tag_names: "Festival, Summer", // (optional) comma separated values
    },

    venue: {
      name: "McCabe's Irish Pub",
      city: "Toronto",
      state: "Ontario",
      country: "Canada",
    },
  },
  function () {
    // success callback, called after data is saved
  },
  function (data) {
    // failure callback, called if something goes wrong
    // error information is provided in the "data" param
  }
);
```

All fields that aren't marked "optional" are required. If a field isn't provided, we'll throw an error message.\

All dates (ie <code>event.start_time</code> etc.) should be provided as strings in ISO 8601 format. If you dont specify a timezone offset in your date, please make sure the time you're passing is in UTC.

Make sure the values for <code>id</code> and <code>event.id</code> are unique per order/event and match what you'd save into your database. You'll use the same order <code>id</code> when updating this order in the future (see the update command below). We use <code>event.id</code>'s to keep track of orders made by different people to the same event.

Ensure the order's <code>status</code> is correctly provided. Currently, there are two values for <code>status</code> that are supported:

- <code>started</code> Use this when a user has started an order but not yet completed it. We'll store the "in progress" order inside Hive and you can use this data to target these users, e.g. send them "abandoned cart" reminder emails.
- <code>completed</code> Use this when a user has fully completed an order, e.g. after payment is confirmed.

After a user completes an order previously marked as <code>started</code> (and saved into Hive as such), use the <code>ticketingOrder.update</code> command below to update its <code>status</code> and other properties

If you provide a value for an event's <code>artist_names</code>, <code>genre_names</code> and <code>tag_names</code>, this will allow users to filter for orders saved in Hive by their event's artists, event genres, and tags and build customer segments and target email/SMS off of these fields.

## Update an Existing Ticketing Order

> To update a previously created order in Hive, use the following command:

```javascript
HIVE_SDK(
  "ticketingOrder",
  "update",
  {
    id: "unique_order_id_1234", // the same unique id for this order as provided in previous "create" commands
    status: "completed", // one of: "started" (order still in progress), "completed" (user has completed order)
    total_paid: 50.75,
  },
  function () {
    // success callback, called after data is saved
  },
  function (data) {
    // failure callback, called if something goes wrong
    // error information is provided in the "data" param
  }
);
```

Orders saved in Hive should be kept up-to-date throughout a user's browsing/checkout/purchasing session (e.g. as they add & remove items from their cart and eventually checkout and complete the order).

The fields <code>id</code> and <code>status</code> are required. If they aren't provided, we'll throw an error message.

Make sure the value for the order's <code>id</code> matches what you used when making the previous <code>ticketingOrder.create</code> command. If you provide an order <code>id</code> that doesn't exist yet, we'll discard the <code>ticketingOrder.update</code> command.

Ensure the value for the order's <code>status</code> is one of the two valid options (<code>started</code> or <code>completed</code>, see above).

Always pass in the most up-to-date value for <code>total_paid</code> as a user's order changes over time.

# Commands - User Properties 

<aside class='info'>
Commands in this group will be buffered until a Contact is linked to them
</aside>

## Set Custom User Properties

This command will set custom user properties on the currently "authenticated" user. Any custom user properties that did not exist before will get created and any existing custom user properties that do exist will be updated.

> Use the following command to set custom user properties on the authenticated user.

```javascript
HIVE_SDK(
  'customUserProperties',
  'update',
  {
    // 'Property Name': 'Property Value'
    'Favorite Color': 'blue',
    'Import ID': 'ABCD123'
  },
  function() {
    // success calback, called after data is saved
  }
  function(data) {
    // failure callback, called if something goes wrong
    // error information is provided in the "data" param
  }
)
```

Note that the values for each custom user property must be a string. Any value passed in that is not a string will be saved as a string.