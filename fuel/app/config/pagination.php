<?php
return array(

	// the active pagination template
	'active'                      => 'default',

	// default FuelPHP pagination template, compatible with pre-1.4 applications
	'default'                     => array(
		'wrapper'                 => "<div class=\"text-center\"><ul class=\"pagination\">\n{pagination}\n</ul></div>\n",

		'first'                   => "<li>\n{link}\n</li>\n",
		'first-marker'            => "&laquo;&laquo;",
		'first-link'              => "<a href=\"{uri}\">{page}</a>\n",

		'first-inactive'          => "",
		'first-inactive-link'     => "",

		'previous'                => "<li>\n{link}\n</li>\n",
		'previous-marker'         => "&laquo;",
		'previous-link'           => "<a href=\"{uri}\" rel=\"prev\">{page}</a>\n",

		'previous-inactive'       => "<li class=\"disabled\">\n{link}\n</li>\n",
		'previous-inactive-link'  => "<a href=\"#\" rel=\"prev\">{page}</a>\n",

		'regular'                 => "<li>\n{link}\n</li>\n",
		'regular-link'            => "<a href=\"{uri}\">{page}</a>\n",

		'active'                  => "<li class=\"active\">\n{link}\n</li>\n",
		'active-link'             => "<a href=\"#\">{page}</a>\n",

		'next'                    => "<li>\n{link}\n</li>\n",
		'next-marker'            => "&raquo;",
		'next-link'               => "<a href=\"{uri}\" rel=\"next\">{page}</a>\n",

		'next-inactive'           => "<li class=\"disabled\">\n{link}\n</span>\n",
		'next-inactive-link'      => "<a href=\"#\" rel=\"next\">{page}</a>\n",

		'last'                    => "<li>\n{link}\n</li>\n",
		'last-marker'             => "&raquo;&raquo;",
		'last-link'               => "<a href=\"{uri}\">{page}</a>\n",

		'last-inactive'           => "",
		'last-inactive-link'      => "",
	),

);
