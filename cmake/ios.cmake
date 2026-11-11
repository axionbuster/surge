# Keep factory content in both executables so the AUv3 does not depend on the host's sandbox.
function(surge_bundle_ios_factory_data target)
  foreach(format Standalone AUv3)
    set(bundle_target ${target}_${format})
    if(TARGET ${bundle_target})
      add_custom_command(TARGET ${bundle_target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
          "${CMAKE_SOURCE_DIR}/resources/data" "$<TARGET_BUNDLE_DIR:${bundle_target}>/SurgeXTData"
        COMMENT "Bundling Surge XT factory content for ${format}"
        VERBATIM)
    endif()
  endforeach()
endfunction()
