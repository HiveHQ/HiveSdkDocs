---
title: Hive Javascript SDK

language_tabs: # must be one of https://git.io/vQNgJ
  - javascript

toc_footers:
  - <a href='https://www.hive.co/'>Powered by Hive</a>

# includes:
#   - errors

search: true
---

# Introduction

Hive SDK allows you to pragmatically power signup forms on your own web properties using custom forms, styling, etc.

# Initialization

> To initialize Hive's SDK on your site, use the following code:

```javascript
(function(h,i,v,e,s,d,k){h.HiveSDKObject=s;h[s]=h[s]||function(){(h[s].q=h[s].q||[]).push(arguments)},d=i.createElement(v),k=i.getElementsByTagName(v)[0];d.async=1;d.src=e;k.parentNode.insertBefore(d,k)})(window,document,'script','https://www.hive.co/jssdk/load/','HIVE_SDK')

HIVE_SDK('init', brand_id, function(user){
  console.log('all inited and ready to go!')
  console.log(user)
});

```

> Make sure to replace `brand_id` with your brand's id. The above command will call the callback function with a user structured like this:

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

Brand id's are whitelisted by domain (subdomains are ok) so make sure that you're running on a domain that's been whitelisted for your brand. If you are not sure that your domain has been whitelisted for your brand please reach out to your account manager.

<aside class='notice'>
You must replace <code>brand_id</code> with your brand's id.
</aside>

# Authentication

## Authenticate with Facebook

```javascript
HIVE_SDK(
  'fbSignup',
  function(data){  // Callback
    console.log('facebook signup success!')
    console.log(data)
  },
  function(data){  // Errback
    console.log('facebook signup failed!');
    console.log(data)
  }
);

```

> The above call will in turn call the callback with the following JSON:

```js
{
  id: 1,
  email: 'm@hive.co',
  first_name: 'Martin',
  last_name: 'Gingras',
  img: 'https://static-hive-images-ticketlabsinc1.netdna-ssl.com/facebook/c_fill,g_faces,h_150,q_30,w_150/502428349.jpg'
}
```


This call will prompt the user to authenticate with Facebook, and either call the callback function with the returned user's data, or the errback function with details regarding what went wrong.


## Authenticate with email

```javascript
var userData = {
  email: 'm@hive.co',
  firstName: 'Martin',
  lastName: 'Gingras',
  location: 'Kitchener, Ontario, Canada'
};
HIVE_SDK(
  'emailSignup',
  userData,
  function(data){  // Callback
    console.log('email signup success!')
    console.log(data)
  },
  function(data){  // Errback
    console.log('email signup failed!')
    console.log(data)
  }
);
```

> The above call will in turn call the callback with the following JSON:

```js
{
  id: 1,
  email: 'm@hive.co',
  first_name: 'Martin',
  last_name: 'Gingras',
  img: 'https://static-hive-images-ticketlabsinc1.netdna-ssl.com/facebook/c_fill,g_faces,h_150,q_30,w_150/502428349.jpg'
}
```


This call will authenticate a user given an email address and data about them.

