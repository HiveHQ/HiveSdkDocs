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

## Whitelist Your Domain

Your website's domain **must** be whitelisted in our system (i.e. approved) before you can run the Hive SDK on it. To whitelist a new domain, please email <a href="mailto:hello@hive.co">hello@hive.co</a>. Domains used for production and development sites can be whitelisted at the same time.

## SDK Initialization

> To initialize the Hive SDK on your site, use the following code:

```javascript
(function(h,i,v,e,s,d,k){h.HiveSDKObject=s;h[s]=h[s]||function(){(h[s].q=h[s].q||[]).push(arguments)},d=i.createElement(v),k=i.getElementsByTagName(v)[0];d.async=1;d.id=s;d.src=e+'?r='+parseInt(new Date()/60000);k.parentNode.insertBefore(d,k)})(window,document,'script','https://cdn-prod.hive.co/static/js/sdk-loader.js','HIVE_SDK')

HIVE_SDK('init', YOUR_BRAND_HIVE_ID, function(data){  // Initialization success callback
  // data.user contains info about the currently user (if available)
  console.log(data)
});

```

> The above command will call the callback function, containing the current user's information if the current user is already authenticated with Hive and your brand:

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

You must initialize the Hive SDK on your website before calling any of the SDK's events (such as <code>fbSignup</code>). Events fired before a call to <code>init</code> will be discarded, while any events fired afterwards (even during initialization) will be handled as soon as initialization is complete.

<aside class='notice'>
  Don't forget to replace <code>YOUR_BRAND_HIVE_ID</code> with your brand's id in Hive. For help finding your brand's id, please email <a href="mailto:hello@hive.co">hello@hive.co</a>.
</aside>

Make sure that you're initializing the SDK on a domain (or subdomain) that's been whitelisted for your brand id. If you are not sure that your domain has been whitelisted for your brand, please reach out to your account manager.

The callback argument in the <code>init</code> call will be executed once the SDK sucessfully initializes. If the current user is authenticated with Hive and your brand, the callback will be passed an object containing a <code>user</code> field including information about the currently authenticated user.

# Add User to Contact List

Making a call to any of the Hive SDK's "signup" events will take care of authenticating the user and adding them to your brand's contact list in Hive. After a user is authenticated, any calls to the SDK's <code>init</code> event will pass that user's data into the init success callback.

## Add via Email Address

> To add a user via an email address, call the following code:

```javascript
HIVE_SDK(
  'emailSignup',
  {
    email: 'patrick@hive.co',
    firstName: 'Patrick',  // optional
    lastName: 'Hannigan',  // optional
    birthday: '01/25/1985',  // optional, MM/DD/YYYY formatted
    location: 'Kitchener, Ontario, Canada',  // optional
    zipCode: 'N2H 3X7',  // optional
    country: 'Canada',  // optional
    city: 'Kitchener',  // optional
    state: 'Ontario',  // optional
    mailingAddress: '283 Duke St West, Unit 304',  // optional
  },
  function(data){  // Success Callback
    // data.user contains info about the currently auth'ed user
    console.log(data)
  },
  function(data){  // Error Callback
    // data contains error information
    console.log(data)
  }
);
```

> The above call will in turn call the 'success' callback with the following JSON:

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

This call will take the provided user data, and use it to authenticate the current user and add them to your brand's contact list in Hive.

The <code>email</code> field is the only required field, although passing along as much data as possible is recommended. For instance, including <code>firstName</code> will help to generate a gender for your contacts in Hive. <code>location</code> should be a string with as much location granularity as possible (we'll take care of geocoding, etc. on our own).

After the signup is successful, the 'success' callback will be called with information about the user. If something goes wrong, the 'error' callback function will be called with details regarding what went wrong.

<aside class='notice'>
  In some rare cases, users signing up with an email address already associated with a Hive admin account will be required to log in using their Hive password. We'll handle redirecting those users to their Hive login page, making sure they're authenticated, and then redirect them back to your website.
</aside>

## Add via Phone Numbber

> To add a user via a phone number, call the following code:

```javascript
HIVE_SDK(
  'phoneNumberSignup',
  {
    phoneNumber: '+15198864500',  // ideally with a country code, i.e. +1 in this example
    didSmsOptIn: true,  // optional

    firstName: 'Patrick',  // optional
    lastName: 'Hannigan',  // optional

    birthday: '01/25/1985',  // optional, MM/DD/YYYY formatted
    location: 'Kitchener, Ontario, Canada',  // optional
    zipCode: 'N2H 3X7',  // optional
    country: 'Canada',  // optional
    city: 'Kitchener',  // optional
    state: 'Ontario',  // optional
    mailingAddress: '283 Duke St West, Unit 304',  // optional
  },
  function(data){  // Success Callback
    // data.user contains info about the currently auth'ed user
    console.log(data)
  },
  function(data){  // Error Callback
    // data contains error information
    console.log(data)
  }
);
```

> The above call will in turn call the 'success' callback with the following JSON:

```js
{
  user: {
    id: 1,  // the user's id in Hive, useful for identifying users if saved within your application
    firstName: 'Patrick',
    lastName: 'Hannigan',
  }
}
```

This call will take the provided user data, and use it to authenticate the current user and add them to your brand's contact list in Hive.

To ensure that phone numbers are properly saved, it is recommended to provide phone numbers in E.164 or RFC3966 format. In cases where Hive cannot resolve a poorly formatted phone number, a default country code of `+1` (United States/Canada) will be assumed.

To ensure you can legally send SMS messages to your contacts via Hive, you must also collect explicit opt-in consent from each user that complies with TCPA. If users have provided you with explicit consent to receive SMS messages, you should pass a value of <code>true</code> for the <code>didSmsOptIn</code> parameter. If this flag is passed in as <code>false</code> (or if this information is not collected at all) the user will still be imported into your Hive account but no SMS messages can be targeted at them.

The <code>phoneNumber</code> field is the only required field, although passing along as much data as possible is recommended. For instance, including <code>firstName</code> will help to generate a gender for your contacts in Hive. <code>location</code> should be a string with as much location granularity as possible (we'll take care of geocoding, etc. on our own).

After the signup is successful, the 'success' callback will be called with information about the user. If something goes wrong, the 'error' callback function will be called with details regarding what went wrong.

# Add Contact to Segment

After a user has been authenticated (either returned in the response of an <code>init</code> call, or by a subsequent <code>emailSignup</code> or <code>fbSignup</code> call), you can add them to a segment within Hive.

## Add to Static Segment

> To add a user to a segment, call the following code:

```javascript
HIVE_SDK(
  'addToSegment',
  'VIP Contacts Segment',  // any segment name you choose
  function(){},  // Success Callback
  function(data){  // Error Callback
    // data contains error information
    console.log(data)
  }
);

```

This call will add the currently authenticated user to a static segment in Hive that matches the name you provide. If a segment does not exist for the name you provided, one will be created.

<aside class='notice'>
  Users must be authenticated and a member of your contact list before you can add them to a segment.
</aside>

