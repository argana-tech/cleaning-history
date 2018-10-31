<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

	<title><?php if (isset($title)): echo $title . ' | '; endif; ?>洗浄歴管理システム</title>

    <!-- Bootstrap core CSS -->
    <?php echo Asset::css('bootstrap.min.css'); ?>
    <?php echo Asset::render('add_css'); ?>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <?php echo Asset::js('html5shiv.js'); ?>
    <?php echo Asset::js('respond.min.js'); ?>
    <![endif]-->
  </head>

  <body>
    <div class="navbar navbar-default navbar-static-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="<?php echo Uri::base(); ?>">洗浄歴管理システム</a>
        </div>

        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li class="dropdown<?php if (strpos(Uri::string(), 'actions') === 0): ?> active<?php endif ?>">
              <a class="dropdown-toggle" data-toggle="dropdown" href="<?php echo Uri::create('/actions') ?>">アクション管理<b class="caret"></b></a>
              <ul class="dropdown-menu">
                <li><a href="<?php echo Uri::create('/actions') ?>">一覧</a></li>
<?php if (isset($current_user) and $current_user->is_admin()): ?>
                <li><a href="<?php echo Uri::create('/actions/new') ?>">新規追加</a></li>
<?php endif; ?>
              </ul>
            </li>
            <li class="dropdown<?php if (strpos(Uri::string(), 'activities') === 0): ?> active<?php endif ?>">
              <a class="dropdown-toggle" data-toggle="dropdown" href="<?php echo Uri::create('/activities'); ?>">洗浄履歴<b class="caret"></b></a>
              <ul class="dropdown-menu">
                <li><a href="<?php echo Uri::create('/activities') ?>">一覧</a></li>
                <li><a href="<?php echo Uri::create('/activities/new') ?>">実施記録登録</a></li>
              </ul>
            </li>
            <li<?php if (strpos(Uri::string(), 'washers') === 0): ?> class="active"<?php endif ?>><a href="<?php echo Uri::create('/washers') ?>">洗浄・消毒機器情報一覧</a></li>
<?php if (isset($current_user) and $current_user->is_admin()): ?>
            <li<?php if (strpos(Uri::string(), 'history') === 0): ?> class="active"<?php endif ?>><a href="<?php echo Uri::create('/history') ?>">操作ログ</a></li>
            <li<?php if (strpos(Uri::string(), 'accounts') === 0): ?> class="active"<?php endif ?>><a href="<?php echo Uri::create('/accounts') ?>">管理者一覧</a></li>
            <li<?php if (strpos(Uri::string(), 'mailto') === 0): ?> class="active"<?php endif ?>><a href="<?php echo Uri::create('/mailto') ?>">通知メール送信先一覧</a></li>
<?php endif ?>
          </ul>
          <ul class="nav navbar-nav navbar-right">
<?php if (isset($current_user)): ?>
            <li><a href="<?php echo Uri::base(); ?>">
                <?php echo e($current_user->getBusyoName()); ?>
                <?php echo e($current_user->getName()); ?>
            </a></li>
<?php endif; ?>
            <li><a href="<?php echo Uri::create('/index/logout'); ?>">ログアウト</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div><!-- /.container -->
    </div>

    <div class="container">
<?php if (Session::get_flash('success')): ?>
      <div class="alert alert-success">
        <a class="close" data-dismiss="alert" aria-hidden="true">&times;</a>
        <span>
          <?php echo implode('</span><span>', e((array) Session::get_flash('success'))); ?>
        </span>
      </div>
<?php endif ?>

<?php if (Session::get_flash('error')): ?>
      <div class="alert alert-danger">
        <a class="close" data-dismiss="alert" aria-hidden="true">&times;</a>
        <span>
          <?php echo implode('</span><span>', e((array) Session::get_flash('error'))); ?>
        </span>
      </div>
<?php endif ?>

      <div class="row">
        <h3><?php echo e($title); ?></h3>
<?php echo $content; ?>
      </div>

      <footer>
        <hr />
        <p class="text-center">Copyright &copy; Tottori University Hospital 2013</p>
      </footer>
    </div> <!-- /container -->

    <!-- Bootstrap core JavaScript
         ================================================== -->
    <?php echo Asset::js('jquery.js'); ?>
    <?php echo Asset::js('jquery.json-2.4.min.js'); ?>
    <?php echo Asset::js('bootstrap.min.js'); ?>
    <?php echo Asset::js('site.js'); ?>
    <script type="text/javascript">
	$(function() {
		$(".dropdown-toggle").dropdown();
		$(".alert").alert();
	});
    </script>
    <?php echo Asset::render('add_js'); ?>
</body>
</html>
