context('Test full procrustes functino')


test_that('Basic procrustes works', {

  # Make sh1, then rotate, resize and translate twice to make sh2 and sh3.

  set.seed(33)
  # Make a shape, then rotate it, then pcr it bake
  sh1 <- matrix(sample(1:48), ncol = 3)

  sh2 <- sh1 * 3

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh2 <- t(apply(sh2, 1, function(x) t(x) %*% R))

  sh2 <- sh2 + 1



  sh3 <- sh1 * 1

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh3 <- t(apply(sh3, 1, function(x) t(x) %*% R))

  sh3 <- sh3 -2


  A <- abind(sh1, sh2, sh3, along = 3)
  # Currently a 4 x 3 x 2 array. We want 2 x 4 x 3
  A <- aperm(A, perm = c(3, 1, 2))

  B <- procrustes(A, scale = TRUE)
  
  expect_equal(B[1, , ], B[2, , ])
  expect_equal(B[2, , ], B[3, , ])
  expect_equal(B[1, , ], B[3, , ])


})


test_that('Missing data procrustes works', {

  set.seed(77)
  # Make a shape, then rotate it, then pcr it bake
  sh1 <- matrix(sample(1:48), ncol = 3)

  sh2 <- sh1 * 3

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh2 <- t(apply(sh2, 1, function(x) t(x) %*% R))

  sh2 <- sh2 + 1



  sh3 <- sh1 * 0.2

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh3 <- t(apply(sh3, 1, function(x) t(x) %*% R))

  sh3 <- sh3 - 2
  
  sh4 <- sh1 * 3
  sh4[1, ] <- NA


  A <- abind(sh1, sh2, sh3, sh4, along = 3)
  # Currently a 4 x 3 x 2 array. We want 2 x 4 x 3
  A <- aperm(A, perm = c(3, 1, 2))

  B <- procrustes(A, scale = TRUE, tolerance = 1e-10)
  
  expect_equal(B[1, , ], B[2, , ])
  expect_equal(B[2, , ], B[3, , ])
  expect_equal(B[1, , ], B[3, , ])



})



test_that('Scale switch and other params work', {

  # 1. Test that scaling changes the result. That all shapes are equal with scaling and not equal without scaling.
  # 2. Test that given shapes that have been rotated and translated but not scaled, all shapes are equal.

  set.seed(12)
  # Make a shape, then rotate it, then pcr it bake
  sh1 <- matrix(sample(1:48), ncol = 3)

  sh2 <- sh1 * 3

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh2 <- t(apply(sh2, 1, function(x) t(x) %*% R))

  sh2 <- sh2 + 1



  sh3 <- sh1 * 5

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh3 <- t(apply(sh3, 1, function(x) t(x) %*% R))

  sh3 <- sh3 - 2
  
  sh4 <- sh1 * 3


  A <- abind(sh1, sh2, sh3, along = 3)
  # Currently a 4 x 3 x 2 array. We want 2 x 4 x 3

  A <- aperm(A, perm = c(3, 1, 2))

  # procrustes with and without scaling.
  B <- procrustes(A, scale = TRUE)
  C <- procrustes(A, scale = FALSE)

  expect_true(all(B[1, , ] - B[2, , ] < 1e-7))
  expect_true(all(B[1, , ] - B[3, , ] < 1e-7))
  expect_true(all(B[2, , ] - B[3, , ] < 1e-7))

  expect_false(all(C[1, , ] - C[2, , ] < 1e-7))
  expect_false(all(C[1, , ] - C[2, , ] < 1e-7))
  expect_false(all(C[1, , ] - C[2, , ] < 1e-7))


  ######################################################

  # Now test that procrustes with scale = FALSE does return identical objects if objects were same size to start with.

  set.seed(122)
  # Make a shape, then rotate it, then pcr it bake
  sh1 <- matrix(sample(1:48), ncol = 3)

  sh2 <- sh1 

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh2 <- t(apply(sh2, 1, function(x) t(x) %*% R))

  sh2 <- sh2 + 1



  sh3 <- sh1 

  x <- runif(1, 0, 2*pi)
  y <- runif(1, 0, 2*pi)
  z <- runif(1, 0, 2*pi)

  R <- rbind(c(cos(x)*cos(y), -cos(z)*sin(y) + sin(z)*sin(x)*cos(y), sin(z)*sin(y) + cos(z)*sin(x)*cos(y)),
             c(cos(x)*sin(y), cos(z)*cos(y) + sin(z)*sin(x)*sin(y)  ,  -sin(z)*cos(y) + cos(z)*sin(x)*sin(y)  ),
             c(-sin(x), sin(z)*cos(x), cos(x)*cos(z)))
  

  sh3 <- t(apply(sh3, 1, function(x) t(x) %*% R))

  sh3 <- sh3 - 2
  
  sh4 <- sh1 


  A <- abind(sh1, sh2, sh3, along = 3)
  # Currently a 4 x 3 x 2 array. We want 2 x 4 x 3

  A <- aperm(A, perm = c(3, 1, 2))

  # procrustes with and without scaling.
  B <- procrustes(A, scale = FALSE)

  expect_true(all(B[1, , ] - B[2, , ] < 1e-7))
  expect_true(all(B[1, , ] - B[3, , ] < 1e-7))
  expect_true(all(B[2, , ] - B[3, , ] < 1e-7))

})
