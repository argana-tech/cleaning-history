<?php
/**
 * The development database settings. These get merged with the global settings.
 */
return array(
	'active' => 'default',

	'default' => array(
		'type'        => 'pdo',
		'connection'  => array(
			'persistent' => false,
			'compress'   => false,
		),
		'table_prefix' => '',
		'charset'      => 'utf8',
		'enable_cache' => true,
		'profiling'    => false,
	),

	'clinical-record' => array(
		'type'        => 'pdo',
		'connection'  => array(
			'persistent' => true,
			'compress'   => false,
		),
		'table_prefix' => '',
		'charset'      => 'utf8',
		'enable_cache' => true,
		'profiling'    => false,
	),

	'patient-record' => array(
		'type'        => 'pdo',
		'connection'  => array(
			'persistent' => true,
			'compress'   => false,
		),
		'table_prefix' => '',
		/* 'charset'      => 'utf8', */
		/* 'enable_cache' => true, */
		/* 'profiling'    => false, */
	),
);
