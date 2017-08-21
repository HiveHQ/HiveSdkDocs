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

The Hive SDK allows you to power signup and authentication on your own web properties and store additional data about your users using Hive's backend.

# SDK Initialization

> To initialize the Hive SDK on your site, use the following code:

```javascript
(function(h,i,v,e,s,d,k){h.HiveSDKObject=s;h[s]=h[s]||function(){(h[s].q=h[s].q||[]).push(arguments)},d=i.createElement(v),k=i.getElementsByTagName(v)[0];d.async=1;d.id=s;d.src=e+'?r='+parseInt(new Date()/60000);k.parentNode.insertBefore(d,k)})(window,document,'script','https://cdn-prod.hive.co/static/js/sdk-loader.js','HIVE_SDK')

HIVE_SDK('init', YOUR_BRANDS_HIVE_ID, function(data){  // Initialization success callback
  // data.user contains info about the currently user (if availiable)
  console.log(data)
});

```

> Make sure to replace `YOUR_BRANDS_HIVE_ID` with your brand's id. The above command will call the callback function, containing the current user's information if the current user is already authenticated with Hive and your brand:

```js
{
  user: {
    id: 1,
    email: 'm@hive.co',
    first_name: 'Martin',
    last_name: 'Gingras',
    img: 'https://static-hive-images-ticketlabsinc1.netdna-ssl.com/facebook/c_fill,g_faces,h_150,q_30,w_150/502428349.jpg'
  }
}
```

You must initialize the Hive SDK on your website before calling any of the SDK's events (such as <code>fbSignup</code>). Events fired before the first <code>init</code> call will be discarded, and any events fired afterwards (even during initialization) will be handled as soon as initialization is complete.

<aside class='notice'>
You must replace <code>YOUR_BRANDS_HIVE_ID</code> with your brand's id in Hive.
</aside>

Make sure that you're initializing the SDK on a domain (or subdomain) that's been whitelisted for your brand id. If you are not sure that your domain has been whitelisted for your brand, please reach out to your account manager.

The callback argument in the <code>init</code> call will be executed once the SDK sucessfully initializes. If the current user is authenticated with Hive and your brand, the callback will be passed an object containing a <code>user</code> field including information about the currently authenticated user.

# Authentication/Signup

Making a call to any of the Hive SDK's "signup" events will take care of authenticating the user and adding them to your brand's contact list in Hive. After a user is authenticated, any calls to the SDK's <code>init</code> event will pass that user's data into the init success callback.

## Sign up via Facebook Connect

```javascript
HIVE_SDK(
  'fbSignup',
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

> If the above call is successful, it will in turn call the 'success' callback with the following JSON:

```js
{
  user: {
    id: 1,  // the user's id in Hive, useful for identifying users if saved within your application
    email: 'm@hive.co',
    first_name: 'Martin',
    last_name: 'Gingras',
    img: 'https://static-hive-images-ticketlabsinc1.netdna-ssl.com/facebook/c_fill,g_faces,h_150,q_30,w_150/502428349.jpg'
  }
}
```

This call will prompt the user to sign up via Facebook, and then add the user to your contact list in Hive.

After authentication/signup is successful, the 'success' callback will be called with information about the user. If something goes wrong, the 'error' callback function will be called with details regarding what went wrong.


## Sign up via email

```javascript
HIVE_SDK(
  'emailSignup',
  {
    email: 'm@hive.co',
    firstName: 'Martin',
    lastName: 'Gingras',
    location: 'Toronto, Ontario, Canada'
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
    email: 'm@hive.co',
    first_name: 'Martin',
    last_name: 'Gingras',
    img: 'https://static-hive-images-ticketlabsinc1.netdna-ssl.com/facebook/c_fill,g_faces,h_150,q_30,w_150/502428349.jpg'
  }
}
```

This call will take the provided user data, and use it to authenticate the current user and add them to your brand's contact list in Hive.

The <code>email</code> field is the only required field, although passing along as much data as possible is recommended. For instance, including <code>firstName</code> will help to generate a gender for your contacts in Hive. <code>location</code> should be a string with as much location granularity as possible (we'll take care of geocoding, etc. on our own).

After authentication/signup is successful, the 'success' callback will be called with information about the user. If something goes wrong, the 'error' callback function will be called with details regarding what went wrong.

